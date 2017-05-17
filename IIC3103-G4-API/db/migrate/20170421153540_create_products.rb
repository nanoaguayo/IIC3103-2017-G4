class CreateProducts < ActiveRecord::Migration[5.0]
  def change
    create_table :products do |t|
      t.string :sku
      t.string :description
      t.string :prodType
      t.integer :unit_cost
      t.integer :lot
      t.float :prod_time
      t.integer :stock
      t.integer :price
      t.timestamps
    end
  end
end
