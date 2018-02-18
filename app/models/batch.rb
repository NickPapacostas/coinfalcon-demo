class Batch < ApplicationRecord
  validates_presence_of :count, :market, :order_type, :operation_type, :percent, :amount
  has_many :orders

  def create(cf_client = CoinfalconExchange.new_client)
    self.save
    generate_orders(cf_client)
  end

  def create_on_coinfalcon(client = CoinfalconExchange.new_client)
    order_params = {
      market: market,
      order_type: order_type,
      operation_type: operation_type,
      size: amount.to_s,
      price: threshold.to_s
    }
    Order.create_on_coinfalcon(self.id, order_params, client)
  end

  def passed_limit?(order_price, new_price)
    if order_type == 'buy'
      new_price > order_price
    else
      new_price < order_price
    end
  end

  def threshold(price = Market.price('IOT-BTC'))
    if order_type == 'buy'
      Order.to_price(price * (1 - (percent / 100.0 )))
    else
      Order.to_price(price * (1 + (percent / 100.0 )))
    end
  end

  def balance_orders(new_price, client = CoinfalconExchange.new_client)
    active_orders = orders
          .map {|o| client.order(o.coinfalcon_id)['data']}
          .reject {|o| o['status'] == 'canceled'}
    
    # cancel orders where price is lower/higher than threshold
    orders_cancelled = active_orders
      .select {|o| passed_limit?(o['price'], new_price)}
      .map {|o| client.cancel(o['coinfalcon_id'])}

    # create orders to meet batch count
    orders_cancelled.length.times do 
      create_on_coinfalcon(client)
    end
  end

  private 

  def generate_orders(cf_client = CoinfalconExchange.new_client)
    count.times do
      create_on_coinfalcon(cf_client)
    end
  end
end