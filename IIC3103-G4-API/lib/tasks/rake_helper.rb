# require 'rails/all'
# require 'openssl'
# require "base64"
# require 'httparty'

# HTTParty::Basement.default_options.update(verify: false)

# module Fetcher
# 	KEY = Rails.env.development? && "z8t4GLUa:TKt0HK" || Rails.env.production && "vTvHgY0Cu&RsQrV"
#   BODEGA_URI = Rails.env.development? && "https://integracion-2017-dev.herokuapp.com/bodega/" || Rails.env.production? && "https://integracion-2017-prod.herokuapp.com/bodega/"
#   #OC_URI =  Rails.env.development? && "http://integracion-2017-dev.herokuapp.com/oc/" || Rails.env.production? && "http://integracion-2017-prod.herokuapp.com/oc/"

#   def self.Bodegas(httpRequest,uri_ext,body = {})
#     auth = generarauthdev(httpRequest)
#     #if Rails.env.production? then
#      # auth = Crypt.generarauthprod(httpRequest)
#     end
#     options = {'Content-type' => 'application/json', 'Authorization' => auth}
#     #JSON body
#     body = body.to_json
#     if httpRequest[0..5] == "DELETE" then
#       response = HTTParty.delete(BODEGA_URI+uri_ext, headers: options, body: body)
#     elsif httpRequest[0..2] == "GET" then
#       response = HTTParty.get(BODEGA_URI+uri_ext, headers: options, body: body)
#     elsif httpRequest[0..2] == "PUT" then
#       response = HTTParty.put(BODEGA_URI+uri_ext, headers: options, body: body)
#     elsif httpRequest[0..3] == "POST" then
#       response = HTTParty.post(BODEGA_URI+uri_ext, headers: options, body: body)
#     end
#     return response
#   end

#   def self.getProductsWithStock
#     almacenes = Bodegas("GET","almacenes")
#     productos = Hash.new 0
#     for almacen in almacenes do
#       id = almacen['_id']
#       resp = Bodegas("GET"+id,"skusWithStock?almacenId="+id)
#       puts resp
#       for aux in resp do
#         productos[aux['_id']] = productos[aux['_id']] + aux['total']
#       end
#     end

#     row_data = Hash.new 0
#     for prod in productos.keys do
#       puts prod
#       row_data[prod] = row_data[prod] + productos[prod]
#     end
#     return row_data
#   end
# 	def generarauth(data)
#     _hash = Base64.encode64(OpenSSL::HMAC.digest(OpenSSL::Digest.new('sha1'),KEY,data)).strip()
#     _hash = "INTEGRACION grupo4:" + _hash
#     return _hash
#   end

# end
# module Crypt
#   # include HHTParty

  

#   #def self.sha1(str)
#    # Digest::SHA1.hexdigest str.to_s
#   #nd

  
# end