class TicketController < ApplicationController
  helper 'spree/products', 'spree/orders'
  def new
    $precio = params[:precio]
    $order5 = params[:order]
    @precioInt = $precio.sub(/\,/, '')[1, $precio.length-3].to_i
    puts @precioInt
    body = {proveedor:"590baa00d6b4ec0004902465",cliente:"Hola",total:@precioInt}
    @responder = Fetcher.Sii("PUT","boleta",body)
    @id = @responder["_id"].to_s
    @url = "https://integracion-2017-dev.herokuapp.com/web/pagoenlinea?callbackUrl=http%3A%2F%2Flocalhost:3000/ticket_accepted&cancelUrl=http%3A%2F%2Flocalhost:3000/ticket_decline&boletaId="+@id
    $order = ActionController::Parameters.new($order5).first[1]

  end
  def accepted
    #Si se acepto primero seteamos el almacen que se va a revisar a 0
    @almacen_revisado = 0
    #Por cada producto en el carrito
    $aux.each do |item_order|
      #Se ve cuanto se requiere despachar
      @porDespachar = item_order.quantity
      #Se buscan todos los almacenes
      @almacenes = Fetcher.Bodegas("GET","almacenes");
      #Mientras queden cosas por desapchar
      while @porDespachar > 0 do
        #Revisamos el stock del almacen
        @stock_producto = Fetcher.Bodegas("GET"+@almacenes[@almacen_revisado]['_id']+item_order.sku,"stock?almacenId="+@almacenes[@almacen_revisado]['_id']+"&sku="+item_order.sku)
        #Si es que hay
        if @stock_producto != nil
          #Se mandan todos los posibles
          for i in 0..@stock_producto.length-1
            #Primero se revisa si esta en la bodega de despacho, si no esta se mueve
            if @almacenes[@almacen_revisado]['_id'] != "590baa76d6b4ec0004902790"
              resp = Fetcher.Bodegas("POST"+@stock_producto[i]['_id']+"590baa76d6b4ec0004902790","moveStock")
            end
            #Una vez movido se prepara el body para despachar
            body = {
              productoId:	@stock_producto[i]['_id'],
              oc:	@id,
              direccion:	"Direccion",
              precio:	@stock_producto[i]['price']
            }
            #Finalmente se despacha
            string = "DELETE"
            string += @stock_producto[i]['_id']+"Direccion"
            string += @stock_producto[i]['price'].to_s
            string += @id.to_s
            resp2 = Fetcher.Bodegas(string,"stock",body)
            #Y se baja en uno la cantidad que falta por despachar
            @porDespachar -= 1
            if @porDespachar == 0
              break
            end
          end
        end
        #Si no se alcanzo a despachar todo se revisa otro almacen
        @almacen_revisado += 1
      end
      #Cuando se envio todo el producto se pasa al siguiente del carro
      @almacen_revisado = 0
    end
  end
  Spree.t(:empty_cart)
end
