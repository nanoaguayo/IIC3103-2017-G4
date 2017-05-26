class Api::PurchaseOrdersController < Api::ApplicationController

  OC_URI =  Rails.env.development? && "http://integracion-2017-dev.herokuapp.com/oc/" || Rails.env.production? && "http://integracion-2017-herokuapp-prod.com/oc/"
  OPT = {'Content-type' => 'application/json'}


  def testMovement
    comprar("grupo1","22","1000","300","",1993214596281)
  end

  def comprar(proveedor,sku,cantidad,precio,comments,fechaE)
    header = {"Content-Type" => "application/json"}
    params = {
      "cliente": "590baa00d6b4ec0004902465", # nuestro dev grupo 4
      "proveedor": "590baa00d6b4ec0004902462", # dev grupo 1
      "sku": sku,
      "fechaEntrega": fechaE,
      "cantidad": cantidad,
      "precioUnitario": precio,
      "canal": "b2b",
    }
    @result = HTTParty.put(OC_URI+"crear", :body => params, :header => OPT)
    case @result.code
    when 200
      @ordenc = JSON.parse(@result.response.body)
      @purchase_order = PurchaseOrder.new(@ordenc)

      if @purchase_order.save then
        puts "Guardada con éxito"
        render json: @result.response.body, status: :OK
      end
    else
    render json: @result.response.body, status: :OK
    end
    return @result
  end

#En este metodo debiesen ir todas las validaciones para aceptar una orden de compra
    def recibir
      #obtener la orden de compra con el id que nos envía el otro grupo.
      body = {}
      body = body.to_json

      id = params[:id]
      oc = HTTParty.get(OC_URI + 'obtener/' + id,headers: OPT, body: body)
      sku = oc['sku']
      #una vez recibida la orden de compra hay que ver si la aceptamos o no
      #de momento no me preocuparía de ver si podemos comprar otras materias primas para producir y cumplir ordenes de comora
      if oc['precioUnitario'] < Products.find_by(sku: sku).unit_cost
        reject(id, 'No seai cagao po compadre')
      elsif Products.find_by(sku: sku).stock < oc['cantidad'] #debería ser comparar contra proyected.
        reject(id, 'No contamos con suficiente stock')
      else
        accept(id)
    end

    end

    def accept(id)#recepcionar
      #hay que afectar nuestro inventario proyectado
      body = {id: id}
      body = body.to_json
      response = HTTParty.post(OC_URI + 'recepcionar/' + id,headers: OPT, body: body)
      #pta en vola hacer algo con eso.
    end

    def reject(id, motive) #rechazar
      if motive != ''
        body = {id: id, rechazo: motive}
      else
        body = {id: id}
      end
      body = body.to_json
      response = HTTParty.post(OC_URI + 'rechazar/' + id, headers: OPT, body: body)

    end

    def cancel(id, motive) #anular
      if motive != ''
        body = {id: id, anulacion: motive}
      else
        body = {id: id}
      end
      body = body.to_json
      response = HTTParty.post(OC_URI + 'anular/' + id,headers: OPT, body: body)
    end
end
