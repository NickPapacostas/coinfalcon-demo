class Batch < ApplicationRecord
  validates_presence_of :count, :market, :order_type, :operation_type, :percent, :amount, :current_price
  has_many :orders, dependent: :destroy

  def create(cf_client = CoinfalconExchange.new_client)
    if valid?
      self.current_price = Order.to_price(threshold)
      self.save
      generate_orders(cf_client)
    end
  end

  def create_on_coinfalcon(client = CoinfalconExchange.new_client)
    price = Order.to_price(threshold)
    order_params = {
      market: market,
      order_type: order_type,
      operation_type: operation_type,
      size: amount.to_s,
      price: price.to_s
    }
    self.current_price = price
    self.save
    Order.create_on_coinfalcon(self.id, order_params, client)
  end

  def passed_limit?(order_price, new_price)
    order_price = Order.to_price(order_price)
    new_price   = Order.to_price(new_price)
    if order_type == 'buy'
      new_price < order_price
    else
      new_price > order_price
    end
  end

  def original_price
    if order_type == 'buy'
      (current_price * (1 + (percent / 100.0 )))
    else
      (current_price * (1 - (percent / 100.0 )))
    end
  end

  def threshold(price = Market.price(market))
    if order_type == 'buy'
      (price * (1 - (percent / 100.0 )))
    else
      (price * (1 + (percent / 100.0 )))
    end
  end

  def balance_orders(new_price, client = CoinfalconExchange.new_client)
    active_orders = orders
          .map {|o| client.order(o.coinfalcon_id)['data']}
          .reject {|o| o['status'] == 'canceled'}
    
    # cancel orders where price is lower/higher than threshold
    orders_cancelled = active_orders
      .select {|o| passed_limit?(original_price, new_price)}
      .map {|o| Order.find_by(coinfalcon_id: o['id']).destroy }



    # create orders to meet batch count
    unless orders_cancelled.empty?
      orders_cancelled.length.times do 
        create_on_coinfalcon(client)
      end

      self.current_price = Order.to_price(threshold(new_price))
      self.save
      broadcast_update()
    end
  end

  def broadcast_update 
    ActionCable.server.broadcast 'batches', 
      message: "balanced", 
      data: {
        batch_id: id, 
        new_order_ids: orders.reload.map(&:coinfalcon_id),
        new_price: self.current_price
      }
  end

  def error_messages
    errors.messages.map{|k,v| "#{k}: #{v[0]}" }.join(', ')
  end

  private 

  def generate_orders(cf_client = CoinfalconExchange.new_client)
    count.times do
      create_on_coinfalcon(cf_client)
    end
  end
end