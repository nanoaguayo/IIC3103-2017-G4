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
    puts result
    if result.code == 200
      proveedor = result[0]["proveedor"]
      proveedor2 = IDS[proveedor.to_s].to_s
      uri = GURI + proveedor2.to_s + ".ing.puc.cl/invoices/" + id.to_s + "/accepted"
      begin
        response =  HTTParty.patch(uri, header: gheader, body: {})
      rescue HTTParty::Error
        puts "error httparty"
      end
      cuenta = JSON.parse(request.raw_post)["bank_account"]
      total = result[0]["total"]
      trans = Banco.transfer(total.to_i, cuenta)
      if trans.code == 200
        resp = HTTParty.patch(GURI + proveedor2.to_s + ".ing.puc.cl/invoices/" + id + "/paid", header: gheader, body: {"id_transaction": trans["_id"]})
        #en esta parte no estaba seguro del nombre del id de la transaccion..
        render json: resp
      else
        render json: trans.response.body
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
    params = {"id": id}
    header = {"Content-Type" => "application/json"}
    result = HTTParty.get(PATH + id, body: params, header: header)
    inv = result.response.body[0]
    if result.code == 200 && inv["estado"] == "pendiente"
      #trx = result[0]["_id"]    #este es el nombre segun el grupo 2
      #puts trx
      #trx = Banco.obtenerTransferencia(trx)
      #monto = trx["monto"]
      #if monto.to_i >= result[0]["total"].to_i #si es que nos pagaron al menos lo que correspondia, entonces se marca como pagada la factura
        result = HTTParty.post(PATH + "pay", header: header, body: params)
        render json: result
      #else
      #  render json: {"error": "monto cancelado es menor al monto de la factura"}
      #end
    else
      render json: inv
    end
  end

end
