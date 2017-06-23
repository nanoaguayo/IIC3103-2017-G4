class PurchaseOrdersController < ApplicationController

  OC_URI =  Rails.env.development? && "http://integracion-2017-dev.herokuapp.com/oc/" || Rails.env.production? && "http://integracion-2017-prod.herokuapp.com/oc/"
  OPT = {'Content-type' => 'application/json'}
  ID_G4 = Rails.env.development? && "590baa00d6b4ec0004902465" || Rails.env.production? && "5910c0910e42840004f6e683"
  IDS = Rails.env.development? && {"590baa00d6b4ec0004902462" => 1,
         "590baa00d6b4ec0004902463" => 2,
         "590baa00d6b4ec0004902464" => 3,
         "590baa00d6b4ec0004902466" => 5,
         "590baa00d6b4ec0004902467" => 6,
         "590baa00d6b4ec0004902468" => 7,
         "590baa00d6b4ec0004902469" => 8,
         1 => "590baa00d6b4ec0004902462",
         2 => "590baa00d6b4ec0004902463",
         3 => "590baa00d6b4ec0004902464",
         5 => "590baa00d6b4ec0004902466",
         6 => "590baa00d6b4ec0004902467",
         7 => "590baa00d6b4ec0004902468",
         8 => "590baa00d6b4ec0004902469"} || Rails.env.production? && {"5910c0910e42840004f6e680" => 1,
          "5910c0910e42840004f6e681" => 2,
          "5910c0910e42840004f6e682" => 3,
          "5910c0910e42840004f6e684" => 5,
          "5910c0910e42840004f6e685" => 6,
          "5910c0910e42840004f6e686" => 7,
          "5910c0910e42840004f6e687" => 8,
          1 => "5910c0910e42840004f6e680",
          2 => "5910c0910e42840004f6e681",
          3 => "5910c0910e42840004f6e682",
          5 => "5910c0910e42840004f6e684",
          6 => "5910c0910e42840004f6e685",
          7 => "5910c0910e42840004f6e686",
          8 => "5910c0910e42840004f6e687"}
  GURI = Rails.env.development? && "http://dev.integra17-" || Rails.env.production? && "http://integra17-"

  def index
    @purchase_orders = Ftp.GetOC()
  end

  def ComprarPostman
    comprar(params[:proveedor], params[:sku], params[:cantidad], params[:precio], params[:fechaE])
  end

  def comprar(proveedor,sku,cantidad,precio,fechaE)
    params = {
      "cliente": ID_G4, # nuestro id grupo 4
      "proveedor": proveedor, # dev grupo 1
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
      @purchase_order = PurchaseOrder.new(@ordenc)#esta parte deguardar las ordenes de compra lo haría solo una vez que nos
      #respondan que la aceptaron
      if @purchase_order.save then
        render json: @result.response.body, status: :OK
        id = @result["_id"]
        puts id
        body = {}
        body = body.to_json
        resp = HTTParty.put(GURI + IDS[proveedor].to_s + ".ing.puc.cl/purchase_orders/#{id}", headers: OPT, body: body)
        #render json: resp // hay que cachar si ellos nos aceptan nuestra oc o no...
        #puts resp
      end
    else
    render json: @result.response.body, status: :OK
    end
  end

#En este metodo debiesen ir todas las validaciones para aceptar una orden de compra
  def recibir
    #obtener la orden de compra con el id que nos envía el otro grupo.
    id = params[:id]
    id_store_reception = JSON.parse(request.body.read.to_s)
    id_store_reception = id_store_reception["id_store_reception"]
    @result = HTTParty.get(OC_URI + 'obtener/' + id, :query => {}, :header => OPT)
    #Reviso si el id ingresado es valido para que oc no tire error
    if @ordenc.key?('created_at') then
      body = {}
      body = body.to_json
      acceptOC = HTTParty.get(OC_URI + 'obtener/' + id, headers: OPT, body: body)
      oc = acceptOC[0]
      cliente = oc["cliente"]
      cliente = IDS[cliente].to_s
      #una vez recibida la orden de compra hay que ver si la aceptamos o no
      #de momento no me preocuparía de ver si podemos comprar otras materias primas para producir y cumplir ordenes de comora
      if accept_general?(oc)
        accept(id, cliente)#esto le avisa a la api del profe y al otro grupo que aceptamos la oc
        @ordenc = JSON.parse(@result.response.body)
        @purchase_order = PurchaseOrder.new(@ordenc) #si aceptamos la OC la guardamos en nuestro modelo.
        InvoicesController.create(oc["_id"])
        render json:{'Message': "Orden creada, aceptada y facturada"}
        #poner en cola
        order = Order.new(oc:oc['_id'], total:Integer(oc['cantidad']), sku:oc['sku'], due_date:oc['fechaEntrega'], client:oc['cliente'], price:Integer(oc['precioUnitario']), destination: id_store_reception, state:"accepted")
        order.save
      end
    else
      render status: 500, json:{
      Message: 'Declined: failed to process order, we need more details'
     }
    end
  end

    def aceptar #cuando se llama por la view para el ftp (Seba)
      id = params[:id]
      @purchase_order = accept(id)
      puts @purchase_order
      @purchase_order_ = PurchaseOrder.new(@purchase_order)
    end

    def accept(id, cliente)#recepcionar
      body = {id: id}
      body = body.to_json
      response = HTTParty.post(OC_URI + 'recepcionar/' + id,headers: OPT, body: body)[0]
      if cliente != ''
        HTTParty.patch(GURI + cliente + ".ing.puc.cl/purchase_orders/#{id}/accepted", headers: OPT, body: {})
      end
      return response
      #pta en vola hacer algo con eso.
    end

    def aceptarPostman
      id = params[:id]
      aux = accept(id, '')
      render json: aux
    end
    def rechazar
      id = params[:id]
      @purchase_order = reject(id,"rechazado en la vista")
      puts @purchase_order
    end

    def reject(id, motive, cliente) #rechazar
      if motive != ''
        body = {id: id, rechazo: motive}
      else
        body = {id: id}
      end
      body = body.to_json
      response = HTTParty.post(OC_URI + 'rechazar/' + id, headers: OPT, body: body)[0]
      if cliente != ''
        HTTParty.patch(GURI + cliente + ".ing.puc.cl/purchase_orders/#{id}/rejected", headers: OPT, body: {})
      end
      return response
    end

    def cancel(id, motive) #anular
      if motive != ''
        body = {id: id, anulacion: motive}
      else
        body = {id: id}
      end
      body = body.to_json
      response = HTTParty.post(OC_URI + 'anular/' + id,headers: OPT, body: body)[0]
      return response
    end

    def CheckStockOC(oc, sku)#se entrega la oc como la respuesta de un request de httparty[0]
      if Product.find_by(sku: sku).stock - oc['cantidad'].to_i < 100
        return false
      else
        return true
      end
    end
    #TODO run with scheduler
    def checkFTP()
      aux = Ftp.GetOC()
      puts aux
      for oc in aux do
        resp = HTTParty.get(OC_URI+"obtener/"+oc[:id], :body => {}, :header => {'Content-type' => 'application/json'})
        if acceptFTP(resp) then
          #accept oc
          accept(oc[:id])
          puts oc
          #Facturar
          fact = InvoicesController.create(oc[:id])
          #poner en cola
          oc2 = resp[0]
          order = Order.new(oc:oc[:id], total:Integer(oc[:qty]), sku:oc[:sku], due_date:oc2['fechaEntrega'], client:oc2['cliente'], price:Integer(oc2['precioUnitario']), destination:"FTP", state:"accepted")
          order.save
        end
      end
    end

    def acceptFTP(oc)
      #cambiar criterios
      if oc[0]["estado"] == "creada" then
        sku = Integer(oc[0]['sku'])
        type = Product.where(sku:sku).first.ptype
        stock = Product.where(sku:sku).first.stock
        if type == "Materia Prima" && then
          #podemos fabricar rapido
          return true
        elsif (stock - Integer(oc[0]["cantidad"])) > 100 then
          #si piden un fabricado, revisar que algo de stock quede
          return true
        end
      end
      return false
    end

    def accept_general?(oc)
      if oc["estado"] == "creada"
        sku = oc["sku"].to_i
        prod = Product.find_by(sku: sku)
        ptype = prod.ptype
        stock = prod.stock
        fecha = Time.at(oc["fechaEntrega"].to_f / 1000)
        if (ptype == "Materia Prima" || (stock - oc["cantidad"].to_i > 100)) && fecha - Time.now > 1.day
          return true
        end
      end
      return false
    end

end
