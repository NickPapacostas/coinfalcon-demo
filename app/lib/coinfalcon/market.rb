class Market
  def self.available_markets
    [
      'IOT-BTC',
      'ETH-BTC',
      'LTC-BTC',
      'ETH-EUR',
      'BTC-EUR',
      'BCH-BTC',
      'INS-BTC',
      'INS-ETH'
    ]
  end

  def self.all_with_price(cf: CoinfalconExchange.new_client, force_update: false)
    # e.g. {'IOT-BTC' => 0.0, 'ETH-BTC' => 0.1} 
    
    if force_update || @last_updated.nil? || ((Time.now - 5.minutes).to_i > @last_updated)   
      @last_updated = Time.now.to_i
      @all_with_price = updated_price_hash(cf)
    else
      @all_with_price
    end
  end

  def self.updated_price_hash(cf = CoinfalconExchange.new_client)
    available_markets.reduce({}) do |hash, market|
      one_week_ago = (Time.now - 1.weeks).utc.iso8601 
      recent_trades = cf.trades(market, one_week_ago)['data']
      if recent_trades.empty?
        hash
      else        
        hash[market] = recent_trades[0]['price']
        hash
      end
    end
  end

  def self.empty_with_price(cf = CoinfalconExchange.new_client)
    available_markets.reduce({}) do |hash, market| 
      hash[market] = 0.0
      hash
    end
  end

  def self.price(market)
    one_week_ago = (Time.now - 1.weeks).utc.iso8601 
    recent_trades = CoinfalconExchange.new_client.trades(market, one_week_ago)['data']
    if !recent_trades.empty?
      recent_trades[0]['price'].to_f
    end
  end

end