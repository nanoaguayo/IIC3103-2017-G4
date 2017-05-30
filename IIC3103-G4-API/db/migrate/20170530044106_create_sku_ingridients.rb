class CreateSkuIngridients < ActiveRecord::Migration[5.0]
  def change
    create_table :sku_ingridients do |t|
      t.integer :sku
      t.integer :ingridient
      t.integer :amount

      t.timestamps
    end
  end
end
