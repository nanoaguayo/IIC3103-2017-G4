class Api::TransactionsController < Api::ApplicationController

  def transfer
    if !(params['origen'] && params['destino'] && params['monto']) then
      render_error('Params missing')
    else
      @transaction = Transaction.create(transaction_params)
      if @transaction.save then
        params[:id] = @transaction.id
        render :show
      else
        render_error('Transaction was not done')
      end
    end
  end

  def show
    @transaction = Transaction.find_by_id(params[:id])
    if @transaction then
      #render
    else
      render_error('Transaction not found')
    end
  end

  def accStatement
    #TODO filter
    @transactions = Transaction.all
    if params['limit'] then
      @tranctions = @transactions.first(params['limit'])
      #render
    else
      #render
    end
  end

  def transaction_params
      params_result = Hash.new
      params_result[:destinationAccount] = params['destino']
      params_result[:originAccount] = params['origen']
      params_result[:amount] = params['monto']
      return params_result
  end

end
