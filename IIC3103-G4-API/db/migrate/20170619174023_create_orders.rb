class CreateOrders < ActiveRecord::Migration[5.0]
  def change
    create_table :orders do |t|
      t.string :oc
      t.string :sku
      t.integer :total
      t.date :due_date
      t.string :destination
      t.integer :price
      t.string :client
      t.string :state

      t.timestamps
    end
  end
end
