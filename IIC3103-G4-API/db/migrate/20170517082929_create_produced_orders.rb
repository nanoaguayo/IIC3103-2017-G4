class CreateProducedOrders < ActiveRecord::Migration[5.0]
  def change
    create_table :produced_orders do |t|
      t.string :sku
      t.integer :cantidad
      t.string :oc_id
      t.timestamps
    end
  end
end
