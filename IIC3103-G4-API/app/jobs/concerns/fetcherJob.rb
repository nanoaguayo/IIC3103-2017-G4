require 'httparty'
HTTParty::Basement.default_options.update(verify: false)

module FetcherJob

  BODEGA_URIJ = Rails.env.development? && "https://integracion-2017-dev.herokuapp.com/bodega/" || Rails.env.production? && "https://integracion-2017-prod.herokuapp.com/bodega/"

  def self.Bodegas(httpRequest,uri_ext,body = {})
    auth = Crypt.generarauth(httpRequest)
    #if Rails.env.production? then
     # auth = Crypt.generarauthprod(httpRequest)

    options = {'Content-type' => 'application/json', 'Authorization' => auth}
    #JSON body
    body = body.to_json
    if httpRequest[0..5] == "DELETE" then
      response = HTTParty.delete(BODEGA_URIJ+uri_ext, headers: options, body: body)
    elsif httpRequest[0..2] == "GET" then
      response = HTTParty.get(BODEGA_URIJ+uri_ext, headers: options, body: body)
    elsif httpRequest[0..2] == "PUT" then
      response = HTTParty.put(BODEGA_URIJ+uri_ext, headers: options, body: body)
    elsif httpRequest[0..3] == "POST" then
      response = HTTParty.post(BODEGA_URIJ+uri_ext, headers: options, body: body)
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

  #Despachar ordenes de FTP
  def self.despacharFtp(sku, cant, adress, oc)
    price = Product.find_by(sku: sku.to_i).price
    transfered = 0
    #do while products have to be dispatched
    while transfered < cant do
      resp = Bodegas("GET"+DESPACHO+sku.to_s,"stock?almacenId="+DESPACHO+"&sku="+sku.to_s)
      puts resp
      count = 0
      for prod in resp do
        sleep(0.8)
        if transfered < cant then
          id_aux = prod['_id']
          resp = dispatchStockFTP(id_aux, oc, adress, price)
          count+=1
          if resp.code == 200
            transfered += 1
          end
        else
          return 0
        end
      end
    end
  end

  #mover productos a la bodega de despacho
  def self.moveToDespacho(sku, cant)
    transfered = 0
    while transfered < cant do
      prods = Bodegas("GET"+ALMACEN1+sku.to_s,"stock?almacenId="+ALMACEN1+"&sku="+sku.to_s)
      count = 0
      for prod in prods do
        sleep(0.8)
        if transfered < cant then
          id_aux = prod['_id']
          resp = moveStock(id_aux,DESPACHO)
          count+=1
          if resp.code == 200
            transfered += 1
          end
        else
          return 0
        end
      end
    end
  end

  #despachar a los otros grupos (todos los productos)
  def self.moveToGroup(sku, cant, to, oc)
    price = Product.find_by(sku: sku.to_i).price
    transfered = 0
    while transfered < cant do
      prods = Bodegas("GET"+DESPACHO+sku.to_s,"stock?almacenId="+DESPACHO+"&sku="+sku.to_s)
      count = 0
      for prod in prods do
        sleep(0.8)
        if transfered < cant then
          id_aux = prod['_id']
          resp = moveStockDispatch(id_aux,to,oc,price)
          count+=1
          if resp.code == 200
            transfered += 1
          end
        else
          return 0
        end
      end
    end
  end

  #Despachar a otro grupo
  def self.moveStockDispatch(id, to, oc, price)
    body = {
      'productoId': id,
      'almacenId': to,
      'oc': oc,
      'precio': price
    }
    resp = Bodegas("POST"+id.to_s+to.to_s,"moveStockBodega",body)
    return resp
  end

  #Despachar ordenes ftp
  def self.dispatchStockFTP(prodId, oc, address, price)
    body = {
      'productoId': prodId,
      'oc': oc,
      'direccion': address,
      'precio': price
    }
    resp = Bodegas("DELETE"+prodId.to_s+address.to_s+price.to_s+oc.to_s,"stock",body)
    return resp
  end

  def self.moveStock(id, to)
    #to = almacenId
    body = {
      'productoId': id,
      'almacenId': to
    }
    resp = Bodegas("POST"+id.to_s+to.to_s,"moveStock",body)
    return resp
  end

end
