class ApplicationJob < ActiveJob::Base
  def client 
    CoinfalconExchange.new_client
  end
end
