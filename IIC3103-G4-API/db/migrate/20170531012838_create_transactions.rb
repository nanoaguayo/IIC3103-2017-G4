class CreateTransactions < ActiveRecord::Migration[5.0]
  def change
    create_table :transactions do |t|
      t.string :origen
      t.string :destino
      t.integer :monto
      t.integer :__v
      t.string :_id

      t.timestamps
    end
  end
end
