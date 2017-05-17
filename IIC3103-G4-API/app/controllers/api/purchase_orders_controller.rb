class Api::PurchaseOrdersController < Api::ApplicationController

    def recibir
      #TODO delete this
      @state = 'pending'
      path = "http://integracion-2017-dev.herokuapp.com/oc/obtener/" + params[:id]
      puts path
      header = {"Content-Type" => "application/json"}
      @result = HTTParty.get(path, :query => {}, :header => header)
      @ordenc = JSON.parse(@result.response.body)[0]
      puts JSON.pretty_generate(@ordenc)
      unless @ordenc.key?('msg')
        @purchase_order = PurchaseOrder.create(@ordenc)
        render json: @result.response.body, status: :ok
      else
        render status: 500, json:{
          Message: 'Declined: failed to process order, we need more details'
        }
      end
    end

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
          puts "ENTROOOOOOOOOOOOOO"
          @ordenc = JSON.parse(@result.response.body)

          @purchase_order = PurchaseOrder.new(@ordenc)
          if @purchase_order.save then
            puts "Guardada con éxito"
          end
      end
      return @result
    end

    def obtener

    end

    def accept
      @state = 'accepted'

    end

    def reject
      @state = 'rejected'

    end

    def cancel
      @state = 'cancelled'

    end

end
