class FechaDespachosType < ActiveRecord::Migration[5.0]
  def change
    change_column :purchase_orders, :fechaDespachos, :text
  end
end
