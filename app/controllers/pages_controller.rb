class PagesController < ApplicationController
  def index
    @batch = Batch.new
  end
end