class FechaDespachosType3 < ActiveRecord::Migration[5.0]
  def change
    change_column :purchase_orders, :fechaDespachos, :string
  end
end
