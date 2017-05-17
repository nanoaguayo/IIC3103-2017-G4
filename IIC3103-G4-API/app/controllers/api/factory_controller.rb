require 'json'

class Api::FactoryController < Api::ApplicationController

  def producir(sku,cantidad)
    lote = (Product.where(sku:sku).first.lot).to_i
    lotesProd = (cantidad/lote).to_i
    if (cantidad % lote) > 0 then
      lotesProd = lotesProd + 1
    end
    if lotesProd*lote <= 5000 then
      if readyToProduce(sku,lotesProd) then
        puts "SE PUEDE"
        a = producirFabrica(sku,cantidad)
        puts a
      else
        puts "NO SE PUEDE"
        render_error("No hay suficientes insumos")
      end
    else
      #Dont send
      producido = 0
      falta = lotesProd
      while (producido < cantidad) do
        temp = 0
        lotestemp = 0
        while (temp <= 5000 && lotestemp <= falta) do
          temp = temp + lote
          lotestemp = lotestemp + 1
        end
        producirFabrica(sku,lote*(lotestemp-1))
        producido = producido + lote*(lotestemp-1)
        falta = falta - (lotestemp-1)
        puts "producido" + producido.to_s
      end
      # render_error("Maximum quantity allowed is 5000")
    end
  end

  def producirFabrica(sku,cantidad)
    body = {sku:sku,cantidad:cantidad}
    responder = Fetcher.Bodegas("PUT"+sku.to_s+cantidad.to_s,"fabrica/fabricarSinPago",body)
    aux = ProducedOrder.create(sku:sku.to_s,cantidad:Integer(cantidad),oc_id:responder['_id'])
    aux.save
    return responder
  end

  def prodForced
      sku = params['sku']
      cantidad = params['cantidad']
      producirFabrica(sku,cantidad)
  end

  def readyToProduce(sku,lotes)
    prodStock = Fetcher.getProductsWithStock
    resp = true
    file = JSON.parse(File.read('./public/formulas.ts'))
    for prod in file["Productos"] do
      # puts prod["nombre"]
      # puts prod["sku"]
      if prod["sku"].to_i == sku.to_i then
        for ing in prod["ingredientes"] do
          # puts ing["nombre"]
          # puts ing["sku"]
          # puts @prodStock[ing["sku"].to_s]
          if ing["requerimiento"].to_i*lotes > prodStock[ing["sku"].to_s].to_i then
            resp = false
            cheap = Fetcher.cheapestProvider(ing["sku"].to_s)
            if cheap == 4 then
              aux = ing['requerimiento'].to_i*lotes
              if aux > 5000 then
                aux = Integer(5000/lotes)*lotes
              end
              producirFabrica(ing['sku'],aux)
            end
          end
        end
      end
    end
    return resp
  end

end
