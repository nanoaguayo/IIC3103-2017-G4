class Api::PurchaseOrdersController < Api::ApplicationController
    def create
      #TODO delete this
      @state = 'pending'
      render :show
      return 0
      params_aux = check_params
      @purchase_order = PurchaseOrder.create(params_aux)
      if @purchase_order.save then
        params[:id] = @purchase_order.id
        render :show, status: 202
      else
        render status: 500, json:{
          Message: 'Declined: failed to process order, we need more details'
        }
      end
    end

    def show
      @purchase_order = PurchaseOrder.find_by_id(params[:id])
      if @purchase_order || TRUE then
          #render show
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
