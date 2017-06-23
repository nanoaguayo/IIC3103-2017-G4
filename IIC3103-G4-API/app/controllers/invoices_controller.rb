class InvoicesController < ApplicationController

  PATH = Rails.env.development? && "http://integracion-2017-dev.herokuapp.com/sii/" || Rails.env.production && "https://integracion-2017-prod.herokuapp.com/sii/"
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

  
  # Crea una factura a partir de una orden de compra
  def create(oc)
    path = Rails.env.development? && "http://integracion-2017-dev.herokuapp.com/sii/" || Rails.env.production && "https://integracion-2017-prod.herokuapp.com/sii/"
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

  def recibir
    #se recibe la factura, y acá tenemos que pagarla 
    path = PATH + "pay/" + params[:id].to_s
    params = {"id": params[:id].to_s}
    header = {"Content-Type" => "application/json"}
    resutl = HTTParty.post(path, body: params, header: header)
    if result.code == 200
      proveedor = JSON.parse(request.headers.read.to_s)
      proveedor = proveedor["X-ACCESS-TOKEN"]
      cuenta = JSON.parse(request.body.read.to_s)
      cuenta = cuenta["bank_account"]
      result = HTTParty.get(PATH + params[:id], body: params, header: header)
      if result.code == 200
        Banco.transfer(result.body["valor_total"],cuenta)#es como el pico la documentacion de facturas asi que nose como se llama bien ese atributo
        #falta cachar bien los nombres de los atributos de las weas de facturas.. creo que está caido el sii ahora.
      end
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

end
