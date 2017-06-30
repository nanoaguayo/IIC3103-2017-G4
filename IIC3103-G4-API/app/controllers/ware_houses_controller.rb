require "thread"
require "date"

class WareHousesController < ApplicationController

  DESPACHO = Rails.env.production? && "5910c0b90e42840004f6e8a5" || Rails.env.development? && "590baa76d6b4ec0004902790"
  ALMACEN1 = Rails.env.production? && "5910c0b90e42840004f6e8a6" || Rails.env.development? && "590baa76d6b4ec0004902791"


  def fabricarMateriaPrima(sku,cantidad)#strings los 2
    prod = Product.find_by(sku: sku.to_i)
    cant = cantidad.to_i
    if cant <= 5000 && cant % prod.lot == 0 then
      monto = prod.cost * cant
      trx = Banco.transferFab(monto)
      trans = JSON.parse(trx.response.body) #esto se lo copié a pelao...
      puts "aa"
      puts trans
      aux = ProducedOrder.create(sku:sku.to_s,cantidad:Integer(cantidad),oc_id:trx['_id'])
      aux.save
      if trans.key?('created_at')#se creo la transferencia bien
        parameters = {
          "trxId": trx['_id'],
          "sku": sku,
          "cantidad": cant
        }
        resp = Fetcher.Bodegas("PUT" + sku.to_s + cantidad.to_s + trx['_id'], "fabrica/fabricar", parameters)
        render json: resp
      else
        render json: {'error': "error con la transferencia"}
      end
    else
      render json: {'error': "se excede la cantidad maxima de 5000, o la cantidad no se ajusta al tamaño del lote"}
    end
  end

  def fabricarElaborado(sku, cantidad)#ambos parametros strings
    prod = Product.find_by(sku: sku.to_i)
    cant = cantidad.to_i
    if cant%prod.lot == 0 && cant <= 5000
      lotes = cant / prod.lot #se calcula la cantidad de lotes a producir
      puts lotes
      ingredientes_necesarios = SkuIngridient.where(sku: sku.to_i)
      enough = true
      insumos = Hash.new 0
      ingredientes_necesarios.each do |ingrediente|
        ing = Product.where(sku: ingrediente.ingridient).first
        puts ing.inspect
        if ingrediente.amount * lotes > ing.stock
          enough = false#en caso de que falte de cualquier ingrediente, no se puede producir
          break
        end
        insumos[ing.sku.to_s] = ingrediente.amount.to_s
      end
      if enough#si hay ingredientes suficientes
        trx = Banco.transferFab(prod.cost * cant)#se paga la produccion al banco
        trans = JSON.parse(trx.response.body)
        #trans = {"__v"=>0, "created_at"=>"2017-06-29T03:53:23.278Z", "updated_at"=>"2017-06-29T03:53:23.278Z", "origen"=>"5910c0910e42840004f6e68c", "destino"=>"5910c0910e42840004f6e67e", "_id"=>"595479b3b70c2a0004295100", "monto"=>1090800}
        aux = ProducedOrder.create(sku:sku.to_s,cantidad:Integer(cantidad),oc_id:trans['_id'])
        aux.save
        if trans.key?('created_at')#si no hubo problemas con la transferencia se continua el flujo
          #ProduceElaboratedJob.perform_later(sku, cantidad, insumos, trans['_id'].to_s)
          parameters = {
            "trxId": trans['_id'].to_s,
            "sku": sku,
            "cantidad": cantidad.to_i
          }
          resp = Fetcher.Bodegas("PUT" + sku.to_s + cantidad + trans['_id'].to_s, "fabrica/fabricar", parameters)
          render json:resp
        else
          render json: {'error': "error con la transferencia"}
        end
      else
        render json: {'error': "no hay suficiente stock de insumos"}
      end
    else
      render json: {'error': "se excede la cantidad maxima de 5000, o la cantidad no se ajusta al tamaño del lote"}
    end
  end

  def fab
    prod = Product.find_by(sku: params[:sku].to_i)
    if prod.ptype == 'Materia Prima'
      fabricarMateriaPrima(params[:sku], params[:cantidad])
    else
      fabricarElaborado(params[:sku], params[:cantidad])
    end
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

  def clean
    CleanBodegaJob.perform_later
  end

  def cleanStorage
    Thread.new do
      loop do
        almacenes = Fetcher.Bodegas("GET","almacenes")
        id_pulmon = ""
        id_recepcion = ""
        otherStorages = Hash.new 0
        for alm in almacenes do
          if alm['pulmon'] && (Integer(alm['usedSpace']) > 0) then
            id_pulmon = alm['_id']
          elsif alm['recepcion'] && (Integer(alm['usedSpace']) > 0) then
            id_recepcion = alm['_id']
          elsif !alm['recepcion'] && !alm['pulmon'] && !alm['despacho'] && (Integer(alm['totalSpace']) - Integer(alm['usedSpace'])>0) then
            otherStorages[alm['_id']] = Integer(alm['totalSpace']) - Integer(alm['usedSpace'])
          end
        end
        break if id_recepcion == "" && id_pulmon == ""
        #Loop to clean all, first recepcion
        if id_recepcion != "" then
          prods = Fetcher.Bodegas("GET"+id_recepcion.to_s,"skusWithStock?almacenId="+id_recepcion.to_s)
          for prod in prods do
            #get products in storage for each sku
            prodList = Fetcher.Bodegas("GET"+id_recepcion.to_s+prod['_id'].to_s,"stock?almacenId="+id_recepcion.to_s+"&sku="+prod['_id']+"&limit=200")
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
        end
        #Move to dispatch storage frm pulmon
        if id_pulmon != "" then
          prods = Fetcher.Bodegas("GET"+id_pulmon.to_s,"skusWithStock?almacenId="+id_pulmon.to_s)
          total = 0
          for prod in prods do
            #get products in storage for each sku
            puts prod
            prodList = Fetcher.Bodegas("GET"+id_pulmon.to_s+prod['_id'].to_s,"stock?almacenId="+id_pulmon.to_s+"&sku="+prod['_id']+"&limit=200")
            count = 3
            while prodList.count > 0 && total < 1026 do
              aux = prodList.pop
              total = total + 1
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
      end
    end
  end

  #Mover a despacho
  def moveToDespachoPostman
    Thread.new do
      sku = params[:sku]
      cant = params[:qty].to_i
      to = DESPACHO
      transfered = 0
      while transfered < cant do
        resp = Fetcher.Bodegas("GET"+ALMACEN1+sku.to_s,"stock?almacenId="+ALMACEN1+"&sku="+sku.to_s)
        count = 0
        for prod in resp do
          if count == 89 then
            sleep(60)
            count = 0
          end
          if transfered < cant then
            id_aux = prod['_id']
            moveStock(id_aux,to)
            count+=1
            transfered+=1
          else
            render json: {"message": "transfered"}
          end
        end
      end
    end
  end

  def moveToDespacho(sku,cant)
    transfered = 0
    while transfered < cant do
      resp = Fetcher.Bodegas("GET"+ALMACEN1+sku.to_s,"stock?almacenId="+ALMACEN1+"&sku="+sku.to_s)
      count = 0
      for prod in resp do
        if count == 89 then
          sleep(60)
          count = 0
        end
        if transfered < cant then
          id_aux = prod['_id']
          moveStock(id_aux,DESPACHO)
          count+=1
          transfered+=1
        else
          return 0
        end
      end
    end
  end

  #Despachar a grupo
  def moveToGroupPostman
    Thread.new do
      sku = params[:sku]
      cant = params[:qty]
      to = params[:to]
      oc = params[:oc]
      price = Product.where(sku:sku).first.price
      transfered = 0
      while transfered < cant do
        resp = Fetcher.Bodegas("GET"+DESPACHO+sku.to_s,"stock?almacenId="+DESPACHO+"&sku="+sku.to_s)
        count = 0
        for prod in resp do
          if count == 89 then
            sleep(60)
            count = 0
          end
          if transfered < cant then
            id_aux = prod['_id']
            moveStockDispatch(id_aux,to,oc,price)
            count+=1
            transfered+=1
          else
            render json: {"message": "movido a grupo"}
          end
        end
      end
      #restar stock
      a = Product.where(sku:sku.to_i).first
      a.stock -= cant
      a.save
    end
  end

  def moveToGroup(sku,cant,to,oc)
    price = Product.where(sku: sku).first.price
    transfered = 0
    while transfered < cant do
      resp = Fetcher.Bodegas("GET"+DESPACHO+sku.to_s,"stock?almacenId="+DESPACHO+"&sku="+sku.to_s)
      count = 0
      for prod in resp do
        if count == 89 then
          sleep(60)
          count = 0
        end
        if transfered < cant then
          id_aux = prod['_id']
          moveStockDispatch(id_aux,to,oc,price)
          count+=1
          transfered+=1
        else
          return 0
        end
      end
    end
    #restar stock
    a = Product.where(sku:sku.to_i).first
    a.stock -= cant
    a.save
  end

  #FTP
  def despacharFtpPostman
    Thread.new do
      #params in body, to has to be non empty string
      sku = params[:sku]
      cant = params[:qty]
      to = params[:to]
      oc = params[:oc]
      price = Product.where(sku: sku).first.price
      transfered = 0
      #do while products have to be dispatched
      while transfered < cant do
        resp = Fetcher.Bodegas("GET"+DESPACHO+sku.to_s,"stock?almacenId="+DESPACHO+"&sku="+sku.to_s)
        puts resp
        count = 0
        for prod in resp do
          if count == 89 && transfered < cant then
            sleep(60)
            count = 0
          end
          if transfered < cant then
            id_aux = prod['_id']
            dispatchStockFTP(id_aux,oc,to,price)
            count+=1
            transfered+=1
          else
            render json: {"message": "despachado"}
          end
        end
      end
      #restar stock
      a = Product.where(sku:sku.to_i).first
      a.stock -= cant
      a.save
    end
  end

  #Despachar ordenes de FTP
  def despacharFtp(sku,cant,to,oc)
    price = Product.where(sku: sku).first.price
    transfered = 0
    #do while products have to be dispatched
    while transfered < cant do
      resp = Fetcher.Bodegas("GET"+DESPACHO+sku.to_s,"stock?almacenId="+DESPACHO+"&sku="+sku.to_s)
      puts resp
      count = 0
      for prod in resp do
        if count == 89 && transfered < cant then
          sleep(60)
          count = 0
        end
        if transfered < cant then
          id_aux = prod['_id']
          dispatchStockFTP(id_aux,oc,to,price)
          count+=1
          transfered+=1
        else
          return 0
        end
      end
    end
    #restar stock
    a = Product.where(sku:sku.to_i).first
    a.stock -= cant
    a.save
  end

  #Despachar a otro grupo
  def moveStockDispatch(id,to,oc,price)
    body = {
      'productoId': id,
      'almacenId': to,
      'oc': oc,
      'precio': price
    }
    resp = Fetcher.Bodegas("POST"+id.to_s+to.to_s,"moveStockBodega",body)
  end

  #Despachar ordenes ftp
  def dispatchStockFTP(prodId,oc,address,price)
    body = {
      'productoId': prodId,
      'oc': oc,
      'direccion': address,
      'precio': price
    }
    resp = Fetcher.Bodegas("DELETE"+prodId.to_s+address.to_s+price.to_s+oc.to_s,"stock",body)
  end

  def moveStock(id,to)
    #to = almacenId
    body = {
      'productoId': id,
      'almacenId': to
    }
    resp = Fetcher.Bodegas("POST"+id.to_s+to.to_s,"moveStock",body)
  end


  #Every hour check queue and dispatch what can be dispatched
  def checkQueue
    #Check queue and deliver
    Thread.new do
      queue = Order.where(['state=?',"accepted"]).order(:due_date)
      products = Fetcher.getProductsWithStock
      for order in queue do
        #Check stock
        puts order
        if products[order.sku] > order.total && !order.due_date.past? then
          #Mover a despacho
          moveToDespacho(order.sku,order.total)
          stock = Product.where(sku:Integer(order.sku)).first.stock
          if order.destination == "FTP" then
            #Despachar
            puts "FTP"
            despacharFtp(order.sku,order.total,"notEmpty",order.oc)
            order.state = "Despachada"
            order.save
          else
            #dispatch to another group
            moveToGroup(order.sku,order.total,order.destination,order.oc)
            order.state = "Despachada"
            order.sav
          end
        else
          #producir

        end
      end
    end
  end
end
