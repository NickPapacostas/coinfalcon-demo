class Batch < ApplicationRecord
  validates_presence_of :count, :market, :order_type, :percent, :amount
  has_many :orders
  after_create :generate_orders

  def generate_orders 
    cf_client = CoinfalconExchange.new(ENV['CF_KEY'], ENV['CF_SECRET'])
    count.times do
      create_on_coinfalcon(cf_client)
    end
  end

  def create_on_coinfalcon(client)
    order_params = {
      market: market,
      order_type: order_type,
      operation_type: operation_type,
      size: amount.to_s,
      price: percent_to_price.to_s
    }
    Order.create_on_coinfalcon(self.id, client, order_params)
  end

  private 

  def percent_to_price
    0.00027800 * 0.5
  end

end