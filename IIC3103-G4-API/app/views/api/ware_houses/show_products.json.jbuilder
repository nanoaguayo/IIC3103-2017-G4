json.message "Listado de productos"
json.almacenes @products do |prod|
  json.id prod.sku
  json.total prod.stock
end
