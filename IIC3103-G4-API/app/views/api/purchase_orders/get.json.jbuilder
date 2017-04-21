json.message "Orden de compra o error"
json.purchase_order @purchase_order do |po|
  json.id po.id
  json.datetime prod.datime
  json.quantity prod.quantity
  json.price prod.price
end
