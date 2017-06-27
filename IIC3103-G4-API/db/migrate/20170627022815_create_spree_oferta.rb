class CreateSpreeOferta < ActiveRecord::Migration[5.0]
  def change
    create_table :spree_oferta do |t|
      t.string :sku
      t.integer :precio
      t.date :inicio
      t.date :fin
      t.string :codigo
      t.boolean :publicar

      t.timestamps
    end
  end
end
