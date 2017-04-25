class CreateProducts < ActiveRecord::Migration[5.0]
  def change
    create_table :products do |t|
      t.string :sku
      t.string :ware_house_id
      t.integer :costs
      t.integer :stock

      t.timestamps
    end
  end
end
