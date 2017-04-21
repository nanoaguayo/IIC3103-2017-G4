class Api::PurchaseOrdersController < Api::ApplicationController
    def create
        #@new_order = Purchase_order.create(purchase_order_params)
        #if @new_order.save then
          render status: 202, json:{
            Message: 'Order accepted'
          }
        #else
        #  render status: 500, json:{
        #    Message: 'Declined: failed to process order, we need more details'
        #  }
        #end
    end

    def receive
    #  @purchase_order = Purchase_order.find(params[:id])
    end

    def reject
    #  @purchase_order = Purchase_order.find(params[:id])
    end

    def cancel
    #  @purchase_order = Purchase_order.find(params[:id])
    end

    def get
    #  @purchase_order = Purchase_order.find(params[:id])
    end

    def purchase_order_params
        params.permit(:id,:product_sku,:qty,:delivery_date,:payment,:payment_option)
    end
end
