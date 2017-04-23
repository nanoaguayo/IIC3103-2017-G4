class CreateBalances < ActiveRecord::Migration[5.0]
  def change
    create_table :balances do |t|
      t.string :account
      t.double :amount

      t.timestamps
    end
  end
end
