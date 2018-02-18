class Order < ApplicationRecord
  belongs_to :batch

  def self.to_price(price)
    "%.5f" % price.to_f
  end

  def self.create_on_coinfalcon(batch_id, order_params, client = CoinfaclonExchange.new_client)
    result = client.create_order(order_params)
    if coinfalcon_id = (result['data'] && result['data']['id'])
      Order.create(batch_id: batch_id, coinfalcon_id: coinfalcon_id)
    else
      raise "Could not create order #{result.inspect}"
    end
  end

  def cancel_and_destroy(client = CoinfaclonExchange.new_client)
    client.cancel_order(self.coinfalcon_id)
    destroy
  end 

end