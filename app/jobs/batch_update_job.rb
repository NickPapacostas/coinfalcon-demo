class BatchUpdateJob < ApplicationJob
  queue_as :default

  def perform(market, new_price = nil)
    new_price ||= Market.price(market)
    Batch.where(market: market).each do |batch|
      batch.balance_orders(new_price)
    end
  end
end