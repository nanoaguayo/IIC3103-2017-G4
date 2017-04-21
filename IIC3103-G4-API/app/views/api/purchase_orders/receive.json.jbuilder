json.message "Orden de compra recibida o error"
json.products @purchase_order do |po|
  json.id po.id
  json.datetime prod.datime
  json.quantity prod.quantity
  json.price prod.price
end
