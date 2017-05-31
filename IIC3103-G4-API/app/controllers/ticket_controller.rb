class TicketController < ApplicationController
  helper 'spree/products', 'spree/orders'
  def new
    $items5 = params[:lista_completa]
    $precio = params[:precio]
    $order5 = params[:order]
    @precioInt = $precio[1, $precio.length].to_i
    body = {proveedor:"590baa00d6b4ec0004902465",cliente:"Hola",total:@precioInt}
    @responder = Fetcher.Sii("PUT","boleta",body)
    @id = @responder["_id"].to_s
    @url = "https://integracion-2017-dev.herokuapp.com/web/pagoenlinea?callbackUrl=http%3A%2F%2Flocalhost:3000/ticket_accepted&cancelUrl=http%3A%2F%2Flocalhost:3000/store/cart&boletaId="+@id
    $order = ActionController::Parameters.new($order5).first[1]
    $items = Spree::LineItem.new($items5)
    #<Spree::LineItem::ActiveRecord_Associations_CollectionProxy:0x007fa228ed6e90>
  end
  def accepted
    @items = [
      {sku:2,description:"Huevo",price:306},
      {sku:4,description:"Aceite de Maravilla",price:1236},
      {sku:8,description:"Trigo",price:756},
      {sku:10,description:"Pan Marraqueta",price:3232},
      {sku:14,description:"Cebada",price:888},
      {sku:16,description:"Pasta de trigo",price:1836},
      {sku:20,description:"Cacao",price:516},
      {sku:26,description:"Sal",price:297},
      {sku:50,description:"Arroz con leche",price:2319},
      {sku:54,description:"Hamburguesas",price:1818},
      {sku:55,description:"Galletas Integrales",price:2775}
    ]
  end
end
