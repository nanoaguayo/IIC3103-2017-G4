require 'httparty'
HTTParty::Basement.default_options.update(verify: false)

module Fetcher

  BODEGA_URI = Rails.env.development? && "https://integracion-2017-dev.herokuapp.com/bodega/" || Rails.env.production? && "https://integracion-2017-prod.herokuapp.com/bodega/"

  def self.Bodegas(httpRequest,uri_ext,body = {})
    auth = Crypt.generarauthdev(httpRequest)
    if Rails.env.production? then
      auth = Crypt.generarauthprod(httpRequest)
    end
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

  def self.getProductsWithStock
   almacenes = Bodegas("GET","almacenes")
   productos = Hash.new 0
   for almacen in almacenes do
     id = almacen['_id']
     resp = Bodegas("GET"+id,"skusWithStock?almacenId="+id)
     for aux in resp do
       productos[aux['_id']] = productos[aux['_id']] + aux['total']
     end
   end

   row_data = Hash.new 0
   for prod in productos.keys do
     row_data[prod] = row_data[prod] + productos[prod]
   end
   return row_data
 end

end
