class CreateInvoices < ActiveRecord::Migration[5.0]
  def change
    create_table :invoices do |t|
      t.string :supplier
      t.string :client
      t.bigint :grossValue
      t.bigint :iva
      t.bigint :totalValue
      t.string :state
      t.datetime :payDate
      t.string :purchaseOrderId
      t.string :rejectionCause
      t.string :cancellationCause

      t.timestamps
    end
  end
end
