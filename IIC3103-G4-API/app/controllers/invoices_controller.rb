class InvoicesController < ApplicationController

  PATH = Rails.env.development? && "http://integracion-2017-dev.herokuapp.com/sii/" || Rails.env.production? && "https://integracion-2017-prod.herokuapp.com/sii/"
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
  ID_G4 = Rails.env.development? && "590baa00d6b4ec0004902465" || Rails.env.production? && "5910c0910e42840004f6e683"
  GURI = Rails.env.development? && "http://dev.integra17-" || Rails.env.production? && "http://integra17-"

  # Crea una factura a partir de una orden de compra
  def create(oc)
    header = {"Content-Type" => "application/json"}
    params = {
      "oc": oc
    }
    @result = HTTParty.put(PATH, :body => params, :header => header)
    case @result.code
    when 200
      @fact = JSON.parse(@result.response.body)
      @fact["oc"] = @fact["oc"]["_id"]
      @invoice = Invoice.new(@fact)
      if @invoice.save then
        puts "Guardada con éxito"
      end
    end
    #render json: @fact, status: :ok
    return @result
  end

  def recibir
    #se recibe la factura, y acá tenemos que pagarla
    id = params[:id].to_s
    params = {"id": id}
    header = {"Content-Type" => "application/json"}
    gheader = {"Content-Type" => "application/json", "X-ACCESS-TOKEN" => ID_G4}
    result = HTTParty.get(PATH + params[:id], body: params, header: header)
    if result.code == 200
      proveedor = result.response.body["proveedor"]
      proveedor = IDS[proveedor.to_s]
      HTTParty.patch(GURI + proveedor.to_s + ".ing.puc.cl/invoices/" + id + "/accepted", header: gheader, body: {})
      cuenta = JSON.parse(request.body.read.to_s)
      cuenta = cuenta["bank_account"]
      trans = Banco.transfer(result.response.body["total"].to_i, cuenta)
      if trans.code == 200
        HTTParty.patch(GURI + proveedor.to_s + ".ing.puc.cl/invoices/" + id + "/paid", header: gheader, body: {"id_transaction": trans.response.body["_id"]})
        #en esta parte no estaba seguro del nombre del id de la transaccion..
      end
    else
      render json: result.response.body
    end
  end

  def createPostman
    #oc in body
    oc = params[:oc]
    #fixed for prod
    path = "https://integracion-2017-prod.herokuapp.com/sii/"
    header = {"Content-Type" => "application/json"}
    params = {
      "oc": oc
    }
    @result = HTTParty.put(path, :body => params, :header => header)
    case @result.code
    when 200
      @fact = JSON.parse(@result.response.body)
      @fact["oc"] = @fact["oc"]["_id"]
      @invoice = Invoice.new(@fact)
      if @invoice.save then
        puts "Guardada con éxito"
      end
    end
    render json: @fact, status: :ok
    return @result
  end

  def show
    @invoice = Invoice.find_by_id(params[:id])
    if @invoice || TRUE then
      #render
    else
      render_error('Invoice not found')
    end
  end

  def paid
    id = params[:id].to_s
    params = {"id": params[:id].to_s}
    header = {"Content-Type" => "application/json"}
    result = HTTParty.get(PATH + params[:id], body: params, header: header)
    if result.code == 200
      trx = JSON.parse(request.body.read.to_s)
      trx = trx["id_transaction"]    #este es el nombre segun el grupo 2
      trx = Banco.obtenerTransferencia(trx)
      monto = trx["monto"]
      if monto.to_i >= result.response.body["total"].to_i #si es que nos pagaron al menos lo que correspondia, entonces se marca como pagada la factura
        result = HTTParty.post(PATH + "pay/" + id, header: header, body: params)
        render json: result.response.body
      else
        render json: {"error": "monto cancelado es menor al monto de la factura"}
      end
    else
      render json: result.response.body
    end
  end

end
