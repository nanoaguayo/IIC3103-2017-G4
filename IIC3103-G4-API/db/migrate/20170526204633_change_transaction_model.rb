class ChangeTransactionModel < ActiveRecord::Migration[5.0]
  def change
    rename_column :transactions, :originAccount ,:origen
    rename_column :transactions, :destinationAccount ,:destino
    rename_column :transactions, :amount ,:monto
    add_column :transactions, :__v, :integer
    add_column :transactions, :_id, :string
  end
end
