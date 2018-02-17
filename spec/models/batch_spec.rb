require 'rails_helper'

RSpec.describe Batch do
  let(:batch) { Batch.new(
    count: 2, 
    market: 'IOT-BTC', 
    order_type: 'buy', 
    operation_type: 'limit_order', 
    amount: 2, 
    percent: 5.0
  )}

  it "calls generate_orders" do
    expect(batch).to receive(:generate_orders)
    batch.create(double())
  end

  it "generates the right number of orders" do
    client = double()
    expect(client)
      .to receive(:create_order)
      .exactly(batch.count).times
      .and_return('data' => {'id' => '123'})

    batch.create(client)
  end


  describe "buy batches" do
    let(:buy_batch) { 
      b = batch.dup
      b.order_type = 'buy'
      b
    }
    
    let(:price) { 1 }


    it "correctly sets threshold" do
      correct_threshold = (1 + (buy_batch.percent / 100.0)) * price
      expect(buy_batch.threshold(price)).to eq(correct_threshold)
    end

    it "correctly tests if passed limit" do
      expect(buy_batch.passed_limit?(price, price + 1)).to eq(true)
    end
  end

  describe "sell batches" do
    let(:sell_batch) { 
      b = batch.dup
      b.order_type = 'sell'
      b
    }
    
    let(:price) { 1 }

    it "correctly sets threshold" do
      correct_threshold = (1 - (sell_batch.percent / 100.0)) * price
      expect(sell_batch.threshold(price)).to eq(correct_threshold)
    end

    it "correctly tests if passed limit" do
      expect(sell_batch.passed_limit?(price, price - 1)).to eq(true)
    end
  end

end