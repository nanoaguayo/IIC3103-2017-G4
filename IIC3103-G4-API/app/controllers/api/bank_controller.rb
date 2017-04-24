class Api::BankController < Api::ApplicationController

  def transfer
    if params['origen'] == NULL or params['destino'] == NULL or params['account'] == NULL then
      render_error('Params missing')
    else
      @transaction = Transaction.create(transaction_params)
      if @transaction.save then
        params[:id] = @transaction.id
        render :show_transaction
      else
        render_error('Transaction was not done')
      end
    end
  end

  def show_transaction
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
    puts @transactions[0]
    if params['limit'] then
      @tranctions = @transactions.first(params['limit'])
      #render
    else
      #render
    end
  end

  def accBalance
      balance = Balance.find_by_id(params[:id])
      if balance then
        render {
          'amount': balance.amount
        }.to_json
      else
        render_error('Account not found')
      end
  end

  def transaction_params
      params.permit(:origen,:destino,:monto)
  end
end
