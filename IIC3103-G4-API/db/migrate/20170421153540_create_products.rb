class CreateProducts < ActiveRecord::Migration[5.0]
  def change
    create_table :products do |t|
      t.string :sku
      t.string :name
      t.integer :price
      t.integer :stock

      t.timestamps
    end
  end
end
