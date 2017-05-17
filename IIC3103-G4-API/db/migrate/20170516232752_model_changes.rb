class ModelChanges < ActiveRecord::Migration[5.0]
  def self.up
    rename_column :purchase_orders, :orderid, :_id
    rename_column :purchase_orders, :channel, :canal
    rename_column :purchase_orders, :delivery_date, :fechaEntrega
    rename_column :purchase_orders, :supplier, :proveedor
    rename_column :purchase_orders, :client, :cliente
    rename_column :purchase_orders, :quantity, :cantidad
    rename_column :purchase_orders, :dispatchedQuantity, :cantidadDespachada
    rename_column :purchase_orders, :unitPrice, :precioUnitario
    rename_column :purchase_orders, :state, :estado
    rename_column :purchase_orders, :rejectionCause, :rechazo
    rename_column :purchase_orders, :cancellationCause, :anulacion
    rename_column :purchase_orders, :notes, :notas
    change_column :purchase_orders, :fechaEntrega, :datetime
    add_column :purchase_orders, :fechaDespachos, :datetime
    add_column :purchase_orders, :__v, :integer
  end

  def self.down
    # rename back if you need or do something else or do nothing
  end
end
