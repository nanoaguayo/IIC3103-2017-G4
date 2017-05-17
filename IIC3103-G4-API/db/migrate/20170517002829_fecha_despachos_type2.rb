class FechaDespachosType2 < ActiveRecord::Migration[5.0]
  def change    
    change_column :purchase_orders, :fechaDespachos, :datetime
  end
end
