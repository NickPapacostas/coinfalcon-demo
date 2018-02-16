class PriceUpdateJob < ApplicationJob
  queue_as :default

  def perform(old_prices = Market.empty_with_price)
    new_prices = Market.all_with_price
    old_prices.each do |market, old_price|
      if old_price != new_prices[market]
        new_price = new_prices[market]
        puts "Updating prices for #{market} #{new_price}"
        BatchUpdateJob.perform_now(market, new_price)
      end
    end

    PriceUpdateJob.set(wait: 15.seconds).perform_later(new_prices)
  end
end