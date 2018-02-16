class Order < ApplicationRecord
  belongs_to :batch

  def self.create_on_coinfalcon(batch_id, order_params, client = CoinfaclonExchange.new_client)
    result = client.create_order(order_params)
    if coinfalcon_id = result['data']['id']
      Order.create(batch_id: batch_id, coinfalcon_id: coinfalcon_id)
    else
      puts "Could not create order"
      puts result.inspect
    end
  end
end