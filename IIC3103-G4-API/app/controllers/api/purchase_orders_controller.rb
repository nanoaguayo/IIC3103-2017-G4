class Api::PurchaseOrdersController < Api::ApplicationController

  OC_URI =  Rails.env.development? && "http://integracion-2017-dev.herokuapp.com/oc/" || Rails.env.production? && "http://integracion-2017-herokuapp-prod.com/oc/"
  OPT = {'Content-type' => 'application/json'}
  ID_G4 = Rails.env.development? && "590baa00d6b4ec0004902465" || Rails.env.production? && "5910c0910e42840004f6e683"
  IDS = Rails.env.development? && {"590baa00d6b4ec0004902462" => 1,
         "590baa00d6b4ec0004902463" => 2,
         "590baa00d6b4ec0004902464" => 3,
         "590baa00d6b4ec0004902466" => 5,
         "590baa00d6b4ec0004902467" => 6,
         "590baa00d6b4ec0004902468" => 7,
         "590baa00d6b4ec0004902469" => 8} || Rails.env.production? && {"5910c0910e42840004f6e680" => 1,
          "5910c0910e42840004f6e681" => 2,
          "5910c0910e42840004f6e682" => 3,
          "5910c0910e42840004f6e684" => 5,
          "5910c0910e42840004f6e685" => 6,
          "5910c0910e42840004f6e686" => 7,
          "5910c0910e42840004f6e687" => 8}
  GURI = Rails.env.development? && "http://dev.integra17-" || Rails.env.production? && "http://integra17-"


  def parametrosComprarHardcoded
    comprar("grupo1","2","5000","200","",1993214596281)
  end

  def comprar(proveedor,sku,cantidad,precio,comments,fechaE)
    params = {
      "cliente": ID_G4, # nuestro id grupo 4
      "proveedor": "590baa00d6b4ec0004902462", # dev grupo 1
      "sku": sku,
      "fechaEntrega": fechaE,
      "cantidad": cantidad,
      "precioUnitario": precio,
      "canal": "b2b",
    }
    puts Rails.env.production?
    puts Rails.env.development?
    @result = HTTParty.put(OC_URI+"crear", :body => params, :header => OPT)
    case @result.code
    when 200
      @ordenc = JSON.parse(@result.response.body)
      @purchase_order = PurchaseOrder.new(@ordenc)
      if @purchase_order.save then
        render json: @result.response.body, status: :OK
        puts @result["_id"]
        #hacer put '/purchase_orders/:id' al proveedor con el id @result["_id"]
      end
    else
    render json: @result.response.body, status: :OK
    end
  end

#En este metodo debiesen ir todas las validaciones para aceptar una orden de compra
    def recibir
      #obtener la orden de compra con el id que nos envía el otro grupo.
      id = params[:id]
      @result = HTTParty.get(OC_URI + 'obtener/' + id, :query => {}, :header => OPT)
      @ordenc = JSON.parse(@result.response.body)[0]
      #Reviso si el id ingresado es valido para que oc no tire error
      if @ordenc.key?('created_at')
        body = {}
        body = body.to_json
        oc = HTTParty.get(OC_URI + 'obtener/' + id, headers: OPT, body: body)[0]
        cliente = oc["cliente"]
        cliente = IDS[cliente]
        sku = oc["sku"].to_i
        #una vez recibida la orden de compra hay que ver si la aceptamos o no
        #de momento no me preocuparía de ver si podemos comprar otras materias primas para producir y cumplir ordenes de comora
          if oc['precioUnitario'].to_i > Product.find_by(sku: sku).price
            render json: reject(id, 'No seai cagao po compadre')
            #HTTParty.patch(GURI + cliente + ".ing.puc.cl/purchase_orders/#{id}/rejected", headers: OPT, body: body)
          elsif Product.find_by(sku: sku).stock < oc['cantidad'].to_i #debería ser comparar contra proyected.
            render json: reject(id, 'No contamos con suficiente stock')
            #HTTParty.patch(GURI + cliente + ".ing.puc.cl/purchase_orders/#{id}/rejected", headers: OPT, body: body)
          else
            render json: accept(id)
            #HTTParty.patch(GURI + cliente + ".ing.puc.cl/purchase_orders/#{id}/accepted", headers: OPT, body: body)
          end
        #render json: @result.response.body, status: :ok
       else
         render status: 500, json:{
          Message: 'Declined: failed to process order, we need more details'
         }
       end
    end

    def accept(id)#recepcionar
      #hay que afectar nuestro inventario proyectado
      body = {id: id}
      body = body.to_json
      response = HTTParty.post(OC_URI + 'recepcionar/' + id,headers: OPT, body: body)[0]
      return response
      #pta en vola hacer algo con eso.
    end

    def reject(id, motive) #rechazar
      if motive != ''
        body = {id: id, rechazo: motive}
      else
        body = {id: id}
      end
      body = body.to_json
      response = HTTParty.post(OC_URI + 'rechazar/' + id, headers: OPT, body: body)[0]

    end

    def cancel(id, motive) #anular
      if motive != ''
        body = {id: id, anulacion: motive}
      else
        body = {id: id}
      end
      body = body.to_json
      response = HTTParty.post(OC_URI + 'anular/' + id,headers: OPT, body: body)[0]
    end

    def CheckOC 
      return true
    end
end
