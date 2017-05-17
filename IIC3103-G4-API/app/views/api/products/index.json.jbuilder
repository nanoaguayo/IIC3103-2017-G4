json.products @products do |prod|
  json.sku prod.sku
  json.name prod.description
  json.price prod.price
  json.stock prod.stock
end
