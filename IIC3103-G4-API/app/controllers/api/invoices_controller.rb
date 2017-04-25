class Api::InvoicesController < Api::ApplicationController
  def create
      po = PurchaseOrder.find_by_id(params[:id])
      if po then
        #process
        ip = Hash.new
        ip['supplier'] = po.supplier
        ip['client'] = po.client
        ip['grossValue'] = Integer(po.quantity*po.unitPrice)
        ip['iva'] = Integer(ip['grossValue']*0.19)
        ip['totalValue'] = ip['grossValue'] + ip['iva']
        ip['state'] = 'pending'
        ip['purchaseOrderId'] = params['id']
        @invoice = Invoice.create(ip)
        if @invoice.save then
          render :show,status:202
        else
          render_error('Invoice could not be processed')
        end
      else
        render_error('Purchase order not found')
      end
  end

  def show
    @invoice = Invoice.find_by_id(params[:id])
    if @invoice then
      #render
    else
      render_error('Invoice not found')
    end
  end

  def accept
    @invoice = Invoice.find_by_id(params[:id])
    if @invoice then
        @invoice.state = "accepted"
        if @invoice.save then
          render :show
        else
          render_error('Could not process your request')
        end
    else
      render_error('Invoice not found')
    end
  end

  def cancel
    @invoice = Invoice.find_by_id(params[:id])
    if @invoice then
        @invoice.state = "rejected"
        if params['cause'] then
          @invoice.cancellationCause = params['cause']
        end
        if @invoice.save then
          render :show
        else
          render_error('Could not process your request')
        end
    else
      render_error('Invoice not found')
    end
  end
  def reject
    @invoice = Invoice.find_by_id(params[:id])
    if @invoice then
        @invoice.state = "rejected"
        if params['cause'] then
          @invoice.rejectionCause = params['cause']
        end
        if @invoice.save then
          render :show
        else
          render_error('Could not process your request')
        end
    else
      render_error('Invoice not found')
    end
  end

  def delivered
    @invoice = Invoice.find_by_id(params[:id])
    if @invoice then
        @invoice.state = "delivered"
        if @invoice.save then
          render :show
        else
          render_error('Could not process your request')
        end
    else
      render_error('Invoice not found')
    end
  end

  def paid
    @invoice = Invoice.find_by_id(params[:id])
    if @invoice then
        @invoice.state = "paid"
        if @invoice.save then
          render :show
        else
          render_error('Could not process your request')
        end
    else
      render_error('Invoice not found')
    end
  end
end
