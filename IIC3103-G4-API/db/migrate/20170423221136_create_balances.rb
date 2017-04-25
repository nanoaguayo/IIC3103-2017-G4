class CreateBalances < ActiveRecord::Migration[5.0]
  def change
    create_table :balances do |t|
      t.string :account
      t.bigint :amount

      t.timestamps
    end
  end
end
