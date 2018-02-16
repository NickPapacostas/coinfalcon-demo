class BatchUpdateJob < ApplicationJob
  queue_as :default

  def perform(market, new_price)
    Batch.where(market: market).each do |batch|
      orders = batch.orders
                .map {|o| client.order(o.coinfalcon_id)['data']}
                .reject {|o| o['status'] == 'canceled'}
      
      # cancel orders where price is lower/higher than threshold
      cancelled_orders = orders
        .select {|o| batch.passed_limit?(o.price, new_price)}
        .map {|o| client.cancel(o.coinfalcon_id)}

      # create orders to meet batch count
      cancelled_orders.length.times do 
        Batch.create_on_coinfalcon(client)
      end
    end
  end
end