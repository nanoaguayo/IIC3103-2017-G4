json.purchase_order
  json.id = @purchase_order.id
  json.created_at = @purchase_order.created_at
  json.channel = @purchase_order.channel
  json.supplier = @purchase_order.supplier
  json.client = @purchase_order.client
  json.sku = @purchase_order.sku
  json.quantity = @purchase_order.quantity
  json.dispatchedQuantity = @purchase_order.dispatchedQuantity
  json.unitPrice = @purchase_order.unitPrice
  json.deadline = @purchase_order.deadline
  json.state = @purchase_order.state
  json.rejectionCause = @purchase_order.rejectionCause
  json.cancellationCause = @purchase_order.cancellationCause
  json.notes = @purchase_order.notes
  json.billid = @purchase_order.billid
end
