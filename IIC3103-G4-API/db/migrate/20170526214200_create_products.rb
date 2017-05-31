class CreateProducts < ActiveRecord::Migration[5.0]
  def change
    create_table :products do |t|
      t.integer :sku
      t.string :description
      t.integer :cost
      t.integer :lot
      t.integer :price
      t.string :ptype
      t.integer :ptime
      t.integer :proyected
      t.integer :stock

      t.timestamps
    end
  end
end
