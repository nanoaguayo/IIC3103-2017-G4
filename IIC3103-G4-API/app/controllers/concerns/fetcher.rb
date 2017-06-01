require 'httparty'
HTTParty::Basement.default_options.update(verify: false)

module Fetcher

  BODEGA_URI = Rails.env.development? && "https://integracion-2017-dev.herokuapp.com/bodega/" || Rails.env.production? && "https://integracion-2017-prod.herokuapp.com/bodega/"
  OC_URI =  Rails.env.development? && "http://integracion-2017-dev.herokuapp.com/oc/" || Rails.env.production? && "http://integracion-2017-herokuapp.com/oc/"
  SII_URI =  Rails.env.development? && "http://integracion-2017-dev.herokuapp.com/sii/" || Rails.env.production? && "http://integracion-2017-herokuapp.com/sii/"
  #OC_URI =  Rails.env.development? && "http://integracion-2017-dev.herokuapp.com/oc/" || Rails.env.production? && "http://integracion-2017-prod.herokuapp.com/oc/"


  def self.Bodegas(httpRequest,uri_ext,body = {})
    auth = Crypt.generarauth(httpRequest)
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
      puts BODEGA_URI+uri_ext
      puts options
      puts body
      response = HTTParty.put(BODEGA_URI+uri_ext, headers: options, body: body)
    elsif httpRequest[0..3] == "POST" then
      response = HTTParty.post(BODEGA_URI+uri_ext, headers: options, body: body)
    end
    return response
  end

  def self.Sii(httpRequest,uri_ext,body = {})
    auth = Crypt.generarauthdev(httpRequest)
    if Rails.env.production? then
      auth = Crypt.generarauthprod(httpRequest)
    end
    options = {'Content-type' => 'application/json', 'Authorization' => auth}
    #JSON body
    body = body.to_json
    if httpRequest[0..5] == "DELETE" then
      response = HTTParty.delete(SII_URI+uri_ext, headers: options, body: body)
    elsif httpRequest[0..2] == "GET" then
      response = HTTParty.get(SII_URI+uri_ext, headers: options, body: body)
    elsif httpRequest[0..2] == "PUT" then
      response = HTTParty.put(SII_URI+uri_ext, headers: options, body: body)
    elsif httpRequest[0..3] == "POST" then
      response = HTTParty.post(SII_URI+uri_ext, headers: options, body: body)
    end
    return response
  end

  def self.getProductsWithStock
    almacenes = Bodegas("GET","almacenes")
    productos = Hash.new 0
    for almacen in almacenes do
      id = almacen['_id'].to_s
      resp = Bodegas("GET"+id,"skusWithStock?almacenId="+id)
      puts resp
      for aux in resp do
        productos[aux['_id']] = productos[aux['_id']] + aux['total']
      end
    end

    row_data = Hash.new 0
    for prod in productos.keys do
      puts prod
      row_data[prod] = row_data[prod] + productos[prod]
    end
    return row_data
  end

  # def self.Provider(sku_ask)
  #   groups = SkuGroup.others.where(sku: sku_ask.to_i).map(&:group)
  #   cheapest_id = 4
  #   best_price = 100000000
  #   groups.each do |n|
  #     other_group_uri = "http://integra17-#{n}.ing.puc.cl/products"
  #     response = HTTParty.get(other_group_uri)
  #     begin
  #       response.each do |product|
  #         if product['sku'] = sku_ask then
  #           if product['price'].to_i < best_price then
  #             best_price = product['price'].to_i
  #             cheapest_id = n
  #           end
  #         end
  #       end
  #     rescue
  #       end
  #   end
  #   return cheapest_id #si retorna 4 es porque no reviso los demás
  # end

#  def self.OC(httpRequest,uri_ext,body = {})
#    options = {'Content-type' => 'application/json'}
#    #JSON body
#    body = body.to_json
#    if httpRequest[0..5] == "DELETE" then
#      response = HTTParty.delete(OC_URI+uri_ext, headers: options, body: body)
#    elsif httpRequest[0..2] == "GET" then
#      response = HTTParty.get(OC_URI+uri_ext, headers: options, body: body)
#    elsif httpRequest[0..2] == "PUT" then
#      response = HTTParty.put(OC_URI+uri_ext, headers: options, body: body)
#    #elsif httpRequest[0..3] == "POST" then
#      response = HTTParty.post(OC_URI+uri_ext, headers: options, body: body)
#    end
#    return response
#  end

end
