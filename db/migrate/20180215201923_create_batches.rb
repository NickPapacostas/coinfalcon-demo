class CreateBatches < ActiveRecord::Migration[5.1]
  def change
    create_table :batches do |t|
      t.integer :count
      t.string :type
      t.float :percent
      t.float :amount
      t.timestamps
    end
  end
end
