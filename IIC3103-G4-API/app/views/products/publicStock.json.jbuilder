json.array!(@products) do |prod|
  json.sku prod.sku
  json.precio prod.price
  json.stock prod.stock
end
