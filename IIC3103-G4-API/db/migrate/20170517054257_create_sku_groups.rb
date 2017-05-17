class CreateSkuGroups < ActiveRecord::Migration[5.0]
  def change
    create_table :sku_groups do |t|
      t.integer :sku
      t.integer :group

      t.timestamps
    end
  end
end
