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
      #Loop to clean all, first recepcion
      if id_recepcion != "" then
        prods = Bodegas("GET"+id_recepcion.to_s,"skusWithStock?almacenId="+id_recepcion.to_s)
        for prod in prods do
          #get products in storage for each sku
          puts prod
          prodList = Bodegas("GET"+id_recepcion.to_s+prod['_id'].to_s,"stock?almacenId="+id_recepcion.to_s+"&sku="+prod['_id']+"&limit=200")
          puts prodList
          count = 3
          while prodList.count > 0 do
            aux = prodList.pop
            for key in otherStorages.keys do
              if otherStorages[key]>0 then
                moveStock(aux['_id'].to_s,key)
                otherStorages[key] = otherStorages[key]-1
                break
              end
            end
            if count == 150 then
                count = 0
                sleep(60)
            end
            if prodList.count == 0 then
                prodList = Bodegas("GET"+id_recepcion.to_s+prod['_id'].to_s,"stock?almacenId="+id_recepcion.to_s+"&sku="+prod['_id']+"&limit=200")
                count = count + 1
            end
            count = count + 1
          end
        end
      end
      #Move to dispatch storage frm pulmon
      if id_pulmon != "" then
        prods = Bodegas("GET"+id_pulmon.to_s,"skusWithStock?almacenId="+id_pulmon.to_s)
        for prod in prods do
          #get products in storage for each sku
          puts prod
          prodList = Bodegas("GET"+id_pulmon.to_s+prod['_id'].to_s,"stock?almacenId="+id_pulmon.to_s+"&sku="+prod['_id']+"&limit=200")
          count = 3
          while prodList.count > 0 do
            aux = prodList.pop
            moveStock(aux['_id'].to_s,id_recepcion)
            if count == 150 then
                count = 0
                sleep(60)
            end
            if prodList.count == 0 then
                prodList = Bodegas("GET"+id_pulmon.to_s+prod['_id'].to_s,"stock?almacenId="+id_pulmon.to_s+"&sku="+prod['_id']+"&limit=200")
                count = count + 1
            end
            count = count + 1
          end
        end
      end
      logger.info "antes de sleep"
      sleep(60)
      logger.info "after sleep"
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
     # auth = CryptJob.generarauthprod(httpRequest)

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
