class PagesController < ApplicationController
  def index
    @batch = Batch.new
    @batches = Batch.all.include(:orders)
  end
end