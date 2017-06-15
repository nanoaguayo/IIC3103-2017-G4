require 'rails/all'
require 'openssl'
require "base64"
require 'httparty'

module Banco
  BANK_URI = Rails.env.development? && "http://integracion-2017-dev.herokuapp.com/banco/" || Rails.env.production? && "https://integracion-2017-prod.herokuapp.com/banco/"
  CUENTA_URI = Rails.env.development? && "https://integracion-2017-dev.herokuapp.com/bodega/fabrica/getCuenta" || Rails.env.production? &&"https://integracion-2017-prod.herokuapp.com/bodega/fabrica/getCuenta"
  ID = Rails.env.development? && "590baa00d6b4ec000490246e" || Rails.env.production? && "5910c0910e42840004f6e68c"

  def self.transferFab(monto)
    path = BANK_URI + "trx"
    cuenta = obtenerCuenta()
    header = {"Content-Type" => "application/json"}
    params = {
      "monto": monto,
      "origen": ID,
      "destino": cuenta
    }
    @result = HTTParty.put(path, :body => params, :header => header)
    case @result.code
    when 200
      @trans = JSON.parse(@result.response.body)
      @transaction = Transaction.new(@trans)
      if @transaction.save then
        puts "Guardada con éxito"
      end
    end
    return @result
  end

  def self.transfer (monto, cuenta)
    path = BANK_URI + "trx"
    header = {"Content-Type" => "application/json"}
    params = {
      "monto": monto,
      "origen": ID,
      "destino": cuenta
    }
    @result = HTTParty.put(path, :body => params, :header => header)
    case @result.code
    when 200
      @trans = JSON.parse(@result.response.body)
      @transaction = Transaction.new(@trans)
      if @transaction.save then
        puts "Guardada con éxito"
      end
    end
    return @result
  end

  def self.obtenerCuenta
    auth = Crypt.generarauth("GET")
    puts auth
    headers = {'Content-type' => 'application/json', 'Authorization' => auth}
    params = {}
    @result = HTTParty.get(CUENTA_URI, :headers => headers)
    cuenta = JSON.parse(@result.response.body)
    puts cuenta["cuentaId"]
    return cuenta["cuentaId"]
  end
end
