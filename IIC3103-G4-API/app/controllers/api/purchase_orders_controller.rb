class Api::PurchaseOrdersController < Api::ApplicationController

  OC_URI =  Rails.env.development? && "http://integracion-2017-dev.herokuapp.com/oc/" || Rails.env.production? && "http://integracion-2017-herokuapp-prod.com/oc/"
  OPT = {'Content-type' => 'application/json'}

  def comprar(proveedor,sku,cantidad,precio,comments,fechaE)
    path = "http://integracion-2017-dev.herokuapp.com/oc/crear"
    puts path
    header = {"Content-Type" => "application/json"}
    params = {
      "cliente": "590baa00d6b4ec0004902465", # nuestro dev grupo 4
      "proveedor": "590baa00d6b4ec0004902462", # dev grupo 1
      "sku": sku,
      "fechaEntrega": fechaE,
      "cantidad": cantidad,
      "precioUnitario": precio,
      "canal": "b2b",
      "notas": comments
    }
    @result = HTTParty.put(path, :body => params, :header => header)
    case @result.code
    when 200
      @ordenc = JSON.parse(@result.response.body)
      @purchase_order = PurchaseOrder.new(@ordenc)
      if @purchase_order.save then
        puts "Guardada con éxito"
      end
    end
    return @result
  end

#En este metodo debiesen ir todas las validaciones para aceptar una orden de compra
    def recibir
      #obtener la orden de compra con el id que nos envía el otro grupo.
      body = {}
      body = body.to_json
      oc = HTTParty.get(OC_URI + 'obtener/' + params[:id],headers: OPT, body: body)
      
    end

    def testMovement
      comprar('prov',22,1000,300,'com',9999999999999)
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
