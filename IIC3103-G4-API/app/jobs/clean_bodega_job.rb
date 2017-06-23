require 'rails/all'
require 'openssl'
require "base64"
require 'httparty'
HTTParty::Basement.default_options.update(verify: false)

class CleanBodegaJob < ApplicationJob
  queue_as :default


  KEY = Rails.env.development? && "z8t4GLUa:TKt0HK" || Rails.env.production? && "vTvHgY0Cu&RsQrV"
  BODEGA_URI = Rails.env.development? && "https://integracion-2017-dev.herokuapp.com/bodega/" || Rails.env.production? && "https://integracion-2017-prod.herokuapp.com/bodega/"

  def perform(*args)
    loop do
      numeroGenerico = 20
      almacenes = Bodegas("GET","almacenes")
      id_pulmon = ""
      id_recepcion = ""
      otherStorages = Hash.new 0
      for alm in almacenes do
        if alm['pulmon'] && alm['usedSpace'] > 0 then
          id_pulmon = alm['_id']
        elsif alm['recepcion'] && alm['usedSpace'] > 0 then
          id_recepcion = alm['_id']
        elsif !alm['recepcion'] && !alm['pulmon'] && !alm['despacho'] && (Integer(alm['totalSpace']) - Integer(alm['usedSpace'])>0) then
          otherStorages[alm['_id']] = Integer(alm['totalSpace']) - Integer(alm['usedSpace'])
        end
      end
      prods = Bodegas("GET"+id_recepcion.to_s,"skusWithStock?almacenId="+id_recepcion.to_s)
      prods.each do |prod|
        prodlist = Bodegas("GET"+id_recepcion.to_s+prod['_id'].to_s,"stock?almacenId="+id_recepcion.to_s+"&sku="+prod['_id']+"&limit=20")
        if numeroGenerico > 0
          while prodlist.count > 0
            aux = prodlist.pop
            for key in otherStorages.keys
              if otherStorages[key] > 0
                moveStock(aux['_id'].to_s, key)
                otherStorages[key] = otherStorages[key] - 1
                numeroGenerico = numeroGenerico - 1
                break
              end
            end
          end
        end
      end
      numeroGenerico = 20
      prods = Bodegas("GET"+id_recepcion.to_s,"skusWithStock?almacenId="+id_pulmon.to_s)
      prods.each do |prod|
        prodlist = Bodegas("GET"+id_recepcion.to_s+prod['_id'].to_s,"stock?almacenId="+id_recepcion.to_s+"&sku="+prod['_id']+"&limit=20")
        if numeroGenerico > 0
          while prodlist.count > 0
            aux = prodlist.pop
            for key in otherStorages.keys
              if otherStorages[key] > 0
                moveStock(aux['_id'].to_s, id_recepcion)
                otherStorages[key] = otherStorages[key] - 1
                numeroGenerico = numeroGenerico - 1
                break
              end
            end
          end
        end
      end
      sleep(5)
      puts 'hola'
    end
  end

  def generarauth(data)
    _hash = Base64.encode64(OpenSSL::HMAC.digest(OpenSSL::Digest.new('sha1'),KEY,data)).strip()
    _hash = "INTEGRACION grupo4:" + _hash
    return _hash
  end

  def Bodegas(httpRequest,uri_ext,body = {})
    auth = generarauth(httpRequest)
    #if Rails.env.production? then
     # auth = Crypt.generarauthprod(httpRequest)

    options = {'Content-type' => 'application/json', 'Authorization' => auth}
    #JSON body
    body = body.to_json
    if httpRequest[0..5] == "DELETE" then
      response = HTTParty.delete(BODEGA_URI+uri_ext, headers: options, body: body)
    elsif httpRequest[0..2] == "GET" then
      response = HTTParty.get(BODEGA_URI+uri_ext, headers: options, body: body)
    elsif httpRequest[0..2] == "PUT" then
      response = HTTParty.put(BODEGA_URI+uri_ext, headers: options, body: body)
    elsif httpRequest[0..3] == "POST" then
      response = HTTParty.post(BODEGA_URI+uri_ext, headers: options, body: body)
    end
    return response
  end


  def moveStock(id,to)
    #to = almacenId
    body = {
      'productoId': id,
      'almacenId': to
    }
    resp = Bodegas("POST"+id.to_s+to.to_s,"moveStock",body)
  end
end
