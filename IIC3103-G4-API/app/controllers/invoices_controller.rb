class InvoicesController < ApplicationController

  # Crea una factura a partir de una orden de compra
  def create(oc)
    path = Rails.env.development? && "http://integracion-2017-dev.herokuapp.com/sii/" || Rails.env.production && "https://integracion-2017-prod.herokuapp.com/sii/"
    header = {"Content-Type" => "application/json"}
    params = {
      "oc": oc
    }
    @result = HTTParty.put(path, :body => params, :header => header)
    case @result.code
    when 200
      @fact = JSON.parse(@result.response.body)
      @fact["oc"] = @fact["oc"]["_id"]
      @invoice = Invoice.new(@fact)
      if @invoice.save then
        puts "Guardada con éxito"
      end
    end
    render json: @fact, status: :ok
    return @result
  end

  def show
    @invoice = Invoice.find_by_id(params[:id])
    if @invoice || TRUE then
      #render
    else
      render_error('Invoice not found')
    end
  end

  def accept
    #TODO delete this
    @state = 'accepted'
    render :show
    return 0
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
    #TODO delete this
    @state = 'cancelled'
    render :show
    return 0
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
    #TODO delete this
    @state = 'rejected'
    render :show
    return 0
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
    #TODO delete this
    @state = 'delivered'
    render :show
    return 0
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
    #TODO delete this
    @state = 'paid'
    render :show
    return 0
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
