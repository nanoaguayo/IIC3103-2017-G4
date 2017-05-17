class Api::PurchaseOrdersController < Api::ApplicationController

    def create
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

    def show
      @purchase_order = PurchaseOrder.find_by_id(params[:id])
      if @purchase_order || TRUE then
          render :show
      else
          render_error('Order not found')
      end
    end

    def receive
      #TODO delete this
      @state = 'accepted'
      render :show
      return 0
      @purchase_order = PurchaseOrder.find_by_id(params[:id])
      if @purchase_order then
        if @purchase_order.state == 'accepted' || @purchase_order.state == 'rejected' then
          render_error('Order already accepted or rejected')
        else
          @purchase_order.state = 'accepted'
          if @purchase_order.save then
            render :show
          else
            render_error('Error: Could not process your request')
          end
        end
      else
        render_error('Order not found')
      end
    end

    def reject
      #TODO delete this
      @state = 'rejected'
      render :show
      return 0
      @purchase_order = PurchaseOrder.find(params[:id])
      if @purchase_order then
        if @purchase_order.state == 'rejected' || @purchase_order.state == 'accepted' then
          render_error('Order already accepted or rejected')
        else
          @purchase_order.state = 'rejected'
          @purchase_order.rejectionCause = params['rechazo']
          if @purchase_order.save then
            render :show
          else
            render_error('Error: Could not process your request')
          end
        end
      else
        render_error('Order not found')
      end
    end

    def cancel
      #TODO delete this
      @state = 'cancelled'
      render :show
      return 0
      @purchase_order = PurchaseOrder.find(params[:id])
      if @purchase_order then
        if @purchase_order.state == 'cancelled' then
          render_error('Order already cancelled')
        else
          @purchase_order.state = 'cancelled'
          @purchase_order.cancellationCause = params['anulacion']
          if @purchase_order.save then
            render :show
          else
            render_error('Error: Could not process your request')
          end
        end
      else
        render_error('Order not found')
      end
    end

    def check_params
      #check params before creation of po
      params_names = ['channel','quantity','sku','client','supplier','unitPrice','deadline','notes']
      params_names2 = ['canal','cantidad','sku','cliente','proveedor','precioUnitario','fechaEntrega','notas']
      params_result = Hash.new
      params_result['dispatchedQuantity'] = 0
      params_result['state'] = 'created'

      params_names2.each_with_index  do |param,index|
          if params[param] then
            params_result[params_names[index]] = params[param]
          end
      end
      return params_result
    end
end
