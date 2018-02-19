class BatchesController < ApplicationController
  def create
    @batch = Batch.new(batch_params)
    if @batch.create
      flash[:notice] = "created"
    else
      flash[:error] = "not created"
    end

    redirect_to root_path
  end

  private 

  def batch_params
    params.require(:batch).permit(:market, :count, :operation_type, :order_type, :percent, :amount)
  end
end