class CreateOrders < ActiveRecord::Migration[5.1]
  def change
    create_table :orders do |t|
      t.integer :batch_id
      t.string :coinfalcon_id
    end
  end
end
