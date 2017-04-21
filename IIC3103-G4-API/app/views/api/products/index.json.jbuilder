json.message "Listado de productos"
json.products @products do |prod|
  json.sku prod.sku
  json.name prod.name
  json.price prod.price
  json.stock prod.stock
end
