class CreatePurchaseOrders < ActiveRecord::Migration[5.0]
  def change
    create_table :purchase_orders do |t|
      t.string :product_sku
      t.integer :qty
      t.string :delivery_date
      t.string :payment
      t.string :payment_option

      t.timestamps
    end
  end
end
