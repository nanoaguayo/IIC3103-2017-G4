class Api::PurchaseOrdersController < Api::ApplicationController
    def create
        params_aux = check_params
        @new_order = Purchase_order.create(params_aux)
        if @new_order.save then
          render status: 202, :show
        else
          render status: 500, json:{
            Message: 'Declined: failed to process order, we need more details'
          }
        end
    end

    def show
      @purchase_order = Purchase_order.find_by_id(params[:id])
      if @purchase_order then
          #render show
      else
          render_error('Order not found')
      end
    end

    def receive
      @purchase_order = Purchase_order.find(params[:id])
      if @purchase_order then
        if @purchase_order.state == 'accepted' || @purchase_order.state = 'rejected' then
          render_error('Order already accepted or rejected')
        else
          @purchase_oder.state = 'accepted'
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
      @purchase_order = Purchase_order.find(params[:id])
      if @purchase_order then
        if @purchase_order.state == 'rejected' || @purchase_order.state == 'accepted' then
          render_error('Order already accepted or rejected')
        else
          @purchase_oder.state = 'rejected'
          @purchase_oder.rejectionCause = params['rechazo']
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
      @purchase_order = Purchase_order.find(params[:id])
      if @purchase_order then
        if @purchase_order.state == 'cancelled' then
          render_error('Order already cancelled')
        else
          @purchase_oder.state = 'cancelled'
          @purchase_oder.cancellationCause = params['anulacion']
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
      params_result['dispatchedQuantity'] = 0
      params_result['state'] = 'created'

      params_names.each do |param|
          if params[param] != NULL then
            params_result = params[param]
          end
      end

      return params_result
    end
end
