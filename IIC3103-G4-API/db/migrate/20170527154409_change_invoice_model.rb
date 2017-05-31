class ChangeInvoiceModel < ActiveRecord::Migration[5.0]
  def change
    rename_column :invoices, :client, :cliente
    rename_column :invoices, :supplier, :proveedor
    rename_column :invoices, :grossValue, :bruto
    rename_column :invoices, :totalValue, :total
    rename_column :invoices, :state, :estado
    remove_column :invoices, :payDate
    rename_column :invoices, :purchaseOrderId, :oc
    remove_column :invoices, :rejectionCause
    remove_column :invoices, :cancellationCause
    add_column :invoices, :__v, :integer
    add_column :invoices, :_id, :string
  end
end
