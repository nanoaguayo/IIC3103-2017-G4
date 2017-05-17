class Api::PurchaseOrdersController < Api::ApplicationController

  def comprar(proveedor,sku,cantidad,precio,comments,fechaE)
    path = "http://integracion-2017-dev.herokuapp.com/oc/crear"
    puts path
    header = {"Content-Type" => "application/json"}
    params = {
      "cliente": "590baa00d6b4ec0004902465", # nuestro dev grupo 4
      "proveedor": "590baa00d6b4ec0004902462", # dev grupo 1
      "sku": sku,
      "fechaEntrega": fechaE,
      "cantidad": cantidad,
      "precioUnitario": precio,
      "canal": "b2b",
      "notas": comments
    }
    @result = HTTParty.put(path, :body => params, :header => header)
    case @result.code
    when 200
      @ordenc = JSON.parse(@result.response.body)
      @purchase_order = PurchaseOrder.new(@ordenc)
      if @purchase_order.save then
        puts "Guardada con éxito"
      end
    end
    return @result
  end

#En este metodo debiesen ir todas las validaciones para aceptar una orden de compra
    def recibir
      @state = 'pending'
      path = "http://integracion-2017-dev.herokuapp.com/oc/obtener/" + params[:id]
      puts path
      header = {"Content-Type" => "application/json"}
      @result = HTTParty.get(path, :query => {}, :header => header)
      @ordenc = JSON.parse(@result.response.body)[0]
      puts JSON.pretty_generate(@ordenc)
      if @ordenc.key?('created_at')
        @purchase_order = PurchaseOrder.create(@ordenc)
        accept
        #render json: @result.response.body, status: :ok
      else
        render status: 500, json:{
          Message: 'Declined: failed to process order, we need more details. '+ @ordenc['msg'].to_s
        }
      end
    end

    def testMovement
      comprar('prov',22,1000,300,'com',9999999999999)
    end

    def obtener
      path = "http://integracion-2017-dev.herokuapp.com/oc/obtener/" + params[:id]
      puts path
      header = {"Content-Type" => "application/json"}
      @result = HTTParty.get(path, :query => {}, :header => header)
      @ordenc = JSON.parse(@result.response.body)[0]
      puts JSON.pretty_generate(@ordenc)
      if @ordenc.key?('created_at')
        render json: @result.response.body, status: :ok
      else
        render status: 500, json:{
          Message: 'Declined: failed to process order, we need more details. '+ @ordenc['msg'].to_s
        }
      end
    end

    def accept
      @state = 'accepted'
      path = "http://integracion-2017-dev.herokuapp.com/oc/recepcionar/" + params[:id]
      puts path
      body = {
            :_id => params[:id]
        }
      header = {"Content-Type" => "application/json"}
      @result = HTTParty.post(path, :body => body.to_json, :headers => header)
      @ordenc = JSON.parse(@result.body)[0]
      puts JSON.pretty_generate(@ordenc)
      if @ordenc.key?('created_at')
        render json: @result.response.body, status: :ok
      else
        render status: 500, json:{
          Message: 'Declined: failed to process order, we need more details. '+ @ordenc['msg'].to_s
        }
      end
    end

    def reject
      @state = 'rejected'
      path = "http://integracion-2017-dev.herokuapp.com/oc/rechazar/" + params[:id]
      puts path
      body = {
            :_id => params[:id],
            :rechazo => "Rechazada por alguna razon"
        }
      header = {"Content-Type" => "application/json"}
      @result = HTTParty.post(path, :body => body.to_json, :headers => header)
      @ordenc = JSON.parse(@result.body)[0]
      puts JSON.pretty_generate(@ordenc)
      if @ordenc.key?('created_at')
        render json: @result.response.body, status: :ok
      else
        render status: 500, json:{
          Message: 'Declined: failed to process order, we need more details. '+ @ordenc['msg'].to_s
        }
      end
    end

    def cancel
      @state = 'cancelled'
      path = "http://integracion-2017-dev.herokuapp.com/oc/anular/" + params[:id]
      puts path
      body = {
        :_id => params[:id],
        :anulacion => "Anulada por alguna razon"
      }
      header = {"Content-Type" => "application/json"}
      @result = HTTParty.delete(path, :body => body.to_json, :headers => header)
      @ordenc = JSON.parse(@result.body)[0]
      puts JSON.pretty_generate(@ordenc)
      if @ordenc.key?('created_at')
        render json: @result.response.body, status: :ok
      else
        render status: 500, json:{
          Message: 'Declined: failed to process order, we need more details. '+ @ordenc['msg'].to_s
        }
      end
    end
end
