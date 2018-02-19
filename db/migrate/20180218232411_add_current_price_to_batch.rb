class AddCurrentPriceToBatch < ActiveRecord::Migration[5.1]
  def change
    add_column :batches, :current_price, :float, default: 0.0, null: false 
  end
end
