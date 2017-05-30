class TicketController < ApplicationController
  helper 'spree/products', 'spree/orders'
  def new
    @precio = params[:precio]
    @order5 = params[:order]
    @precioInt = @precio[1, @precio.length].to_i
    body = {proveedor:"590baa00d6b4ec0004902465",cliente:"Hola",total:@precioInt}
    @responder = Fetcher.Sii("PUT","boleta",body)
    @id = @responder["_id"].to_s
    @url = "https://integracion-2017-dev.herokuapp.com/web/pagoenlinea?callbackUrl=http%3A%2F%2Flocalhost:3000/store&cancelUrl=http%3A%2F%2Flocalhost:3000/store/cart&boletaId="+@id
    @order = ActionController::Parameters.new(@order5).first[1]
    end
end
