require 'json'

class Api::FactoryController < Api::ApplicationController

  def producir(sku,cantidad)
    
    lote = (Product.where(sku:sku).first.lot).to_i
    lotesProd = (cantidad/lote).to_i
    if (cantidad % lote) > 0 then
      lotesProd = lotesProd + 1
    end
    if lotesProd*lote <= 5000 then

      # if readyToProduce(sku,lotesProd) then
      if true then
        puts "SE PUEDE"
        producirFabrica(sku,cantidad)
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
    puts "ya producido: " + cantidad.to_s
    return responder
  end

  def readyToProduce(sku,lotes)
    @prodStock = Fetcher.getProductsWithStock
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
          if ing["requerimiento"].to_i*lotes > @prodStock[ing["sku"].to_s].to_i then
            resp = false
          end
        end
      end
    end

    return resp
  end


end
