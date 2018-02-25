class BatchesController < ApplicationController
  def create
    @batch = Batch.new(batch_params)
    if @batch.create
      flash[:notice] = "Batch (#{@batch.order_type}) with #{@batch.orders.count} orders created"
    else
      flash[:error] = @batch.error_messages
    end

    redirect_to root_path
  end

  def destroy
    @batch = Batch.find(params[:id])
    order_count = @batch.orders.count
    if @batch.destroy
      flash[:notice] = "Batch #{params[:id]} and #{order_count} orders destroyed"
    else
      flash[:error] = @batch.error_messages
    end

    redirect_to root_path
  end

  private 

  def batch_params
    params.require(:batch).permit(:market, :count, :operation_type, :order_type, :percent, :amount)
  end
end