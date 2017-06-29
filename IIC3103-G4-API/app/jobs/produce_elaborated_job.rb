class ProduceElaboratedJob < ApplicationJob
  queue_as :default
  
  def perform(sku, cantidad, insumos, trxId)
    insumos.keys.each do |insumo| #insumos es un hash con el sku del insumo como llave y la cantidad como valor
      FetcherJob.moveToDespacho(insumo, insumos[insumo].to_i)
    end
    parameters = {
      "trxId": trxId,
      "sku": sku,
      "cantidad": cantidad.to_i
    }
    resp = FetcherJob.Bodegas("PUT" + sku + cantidad + trxId, "fabrica/fabricar", parameters)
    #acá habria que guardar esta wea producida dentro de nuestro modelo produced orders.
  end
end
