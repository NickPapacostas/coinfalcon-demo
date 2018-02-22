class PagesController < ApplicationController
  def index
    @batch = Batch.new
    @batches = Batch.all #.include(:orders)
    @markets = Market.all_with_price
  end
end