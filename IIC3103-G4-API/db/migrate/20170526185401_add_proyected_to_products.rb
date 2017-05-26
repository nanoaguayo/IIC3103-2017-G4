class AddProyectedToProducts < ActiveRecord::Migration[5.0]
  def change
    add_column :products, :proyected, :integer
  end
end
