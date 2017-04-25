class CreateTransactions < ActiveRecord::Migration[5.0]
  def change
    create_table :transactions do |t|
      t.string :originAccount
      t.string :destinationAccount
      t.bigint :amount

      t.timestamps
    end
  end
end
