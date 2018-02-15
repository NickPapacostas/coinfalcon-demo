class Order < ApplicationRecord
  belongs_to :batch

  def self.create_on_coinfalcon(batch_id, client = new_client, order_params)
    result = client.create_order(order_params)
    if coinfalcon_id = result['data']['id']
      Order.create(batch_id: batch_id, coinfalcon_id: coinfalcon_id)
    else
      puts "Could not create order"
      puts result.inspect
    end
  end

  private 

  def new_client
    CoinfalconExchange.new(ENV['CF_KEY'], ENV['CF_SECRET'])
  end
end