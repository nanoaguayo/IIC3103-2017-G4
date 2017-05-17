class CreateWareHouses < ActiveRecord::Migration[5.0]
  def change
    create_table :ware_houses do |t|
      t.integer :usedspace
      t.integer :totalspace
      t.boolean :reception
      t.boolean :dispatch
      t.boolean :pulmon

      t.timestamps
    end
  end
end
