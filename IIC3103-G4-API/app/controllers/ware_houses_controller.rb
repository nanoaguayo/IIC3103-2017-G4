class WareHousesController < ApplicationController

  def fabricar(sku,cantidad)#strings los 2
    prod = Product.find_by(sku: sku.to_i)
    cant = cantidad.to_i
    if cant <= 5000 then
      monto = prod.cost * cant
      trx = Banco.transferFab(monto)
      trans = JSON.parse(trx.response.body) #esto se lo copié a pelao...
      if trans.key?('created_at')#se creo la transferencia bien
        parameters = {
          "trxId": trx['_id'],
          "sku": sku,
          "cantidad": cantidad.to_i
        }
        puts parameters
        puts "PUT" + sku + cantidad + trx['_id']
        resp = Fetcher.Bodegas("PUT" + sku + cantidad + trx['_id'], "fabrica/fabricar", parameters)
        render json: resp
      else
        render_error("error con la transferencia")
      end
    else
      #Dont send
      render_error("Maximum quantity allowed is 5000")
    end
  end

  def fab
    fabricar(params[:sku], params[:cantidad])
  end
  #update local stock
  def updateStock
    products = Product.all
    almacenes = Fetcher.Bodegas("GET","almacenes")
    newStock = Hash.new 0
    for alm in almacenes do
      stock = Fetcher.Bodegas("GET"+alm['_id'],"skusWithStock?almacenId="+alm['_id'])
      for aux in stock do
        newStock[aux['_id']] = newStock[aux['_id']] + aux['total']
      end
    end
    for key in newStock.keys do
      prodAux = Product.where(sku:key).first
      prodAux.stock = newStock[key]
      prodAux.save
    end
  end
  def testingjobs
    CleanBodegaJob.perform_later
  end

  def cleanStorage
      almacenes = Fetcher.Bodegas("GET","almacenes")
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
      prods = Fetcher.Bodegas("GET"+id_recepcion.to_s,"skusWithStock?almacenId="+id_recepcion.to_s)
      for prod in prods do
        #get products in storage for each sku
        puts prod
        prodList = Fetcher.Bodegas("GET"+id_recepcion.to_s+prod['_id'].to_s,"stock?almacenId="+id_recepcion.to_s+"&sku="+prod['_id']+"&limit=200")
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
          if count == 89 then
              count = 0
              sleep(60)
          end
          if prodList.count == 0 then
              prodList = Fetcher.Bodegas("GET"+id_recepcion.to_s+prod['_id'].to_s,"stock?almacenId="+id_recepcion.to_s+"&sku="+prod['_id']+"&limit=200")
              count = count + 1
          end
          count = count + 1
        end
      end
      #Move to dispatch storage frm pulmon
      prods = Fetcher.Bodegas("GET"+id_pulmon.to_s,"skusWithStock?almacenId="+id_pulmon.to_s)
      for prod in prods do
        #get products in storage for each sku
        puts prod
        prodList = Fetcher.Bodegas("GET"+id_pulmon.to_s+prod['_id'].to_s,"stock?almacenId="+id_pulmon.to_s+"&sku="+prod['_id']+"&limit=200")
        count = 3
        while prodList.count > 0 do
          aux = prodList.pop
          moveStock(aux['_id'].to_s,id_recepcion)
          if count == 89 then
              count = 0
              sleep(60)
          end
          if prodList.count == 0 then
              prodList = Fetcher.Bodegas("GET"+id_pulmon.to_s+prod['_id'].to_s,"stock?almacenId="+id_pulmon.to_s+"&sku="+prod['_id']+"&limit=200")
              count = count + 1
          end
          count = count + 1
        end
      end
  end

  def moveStock(id,to)
    #to = almacenId
    body = {
      'productoId': id,
      'almacenId': to
    }
    resp = Fetcher.Bodegas("POST"+id.to_s+to.to_s,"moveStock",body)
  end

  def checkStock
    prods = Fetcher.getProductsWithStock
    products = Product.all
    min_lot = 12
    for prod in products do
      if prods[prod.sku] < min_lot * prod.lot then
        #produce
        numToProd = Integer( ((min_lot * prod.lot) - prods[prod.sku])/prod.lot)
        numToProd = numToProd * prod.lot
        FactoryController.producir(prod.sku,numToProd)
      end
    end
  end

  #TODO check if working
  def dispatchStock(prodId,oc,address,price)
    body = {
      'productoId': prodId,
      'oc': oc,
      'direccion': address,
      'precio': price
    }
    resp = Fetcher.Bodegas("DELETE"+prodId.to_s+address.to_s+price.to_s+oc.to_s,"stock",)
    render json:resp
  end
end
