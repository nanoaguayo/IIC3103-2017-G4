json.message "Listado de productos"
json.products @products do |prod|
  json.sku prod.sku
  json.warehouse prod.ware_house_id
  json.price prod.price
  json.stock prod.stock
end
