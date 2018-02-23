class Order < ApplicationRecord
  belongs_to :batch

  before_destroy :cancel

  def self.to_price(price)
    ("%.5f" % price).to_f
  end

  def get_from_coinfalcon(client = CoinfalconExchange.new_client)
    client.order(self.coinfalcon_id)
  end

  def self.create_on_coinfalcon(batch_id, order_params, client = CoinfalconExchange.new_client)
    result = client.create_order(order_params)
    if coinfalcon_id = (result['data'] && result['data']['id'])
      Order.create(batch_id: batch_id, coinfalcon_id: coinfalcon_id)
    else
      raise "Could not create order #{result.inspect}"
    end
  end

  def cancel(client = CoinfalconExchange.new_client)
    client.cancel_order(self.coinfalcon_id)
  end 
end