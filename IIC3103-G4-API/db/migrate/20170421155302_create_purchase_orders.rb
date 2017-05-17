class CreatePurchaseOrders < ActiveRecord::Migration[5.0]
  def change
    create_table :purchase_orders do |t|
      t.string :orderid
      t.string :channel
      t.string :delivery_date
      t.string :supplier
      t.string :client
      t.string :sku
      t.integer :quantity
      t.integer :dispatchedQuantity
      t.integer :unitPrice
      t.datetime :deadline
      t.string :state
      t.string :rejectionCause
      t.string :cancellationCause
      t.string :notes
      t.string :billid
      t.timestamps
    end
  end
end
