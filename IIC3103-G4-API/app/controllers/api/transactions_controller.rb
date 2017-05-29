class Api::TransactionsController < Api::ApplicationController

  def transfer(monto)
    path = Rails.env.development? && "http://integracion-2017-dev.herokuapp.com/banco/trx" || Rails.env.production && "https://integracion-2017-prod.herokuapp.com/banco/trx"
    cuenta = obtenerCuenta()
    header = {"Content-Type" => "application/json"}
    params = {
      "monto": monto, # nuestro dev grupo 4
      "origen": "590baa00d6b4ec000490246e", #dev
      #"origen": "5910c0910e42840004f6e68c" #prod
      "destino": cuenta
    }
    @result = HTTParty.put(path, :body => params, :header => header)
    case @result.code
    when 200
      @trans = JSON.parse(@result.response.body)
      @transaction = Transaction.new(@trans)
      if @transaction.save then
        puts "Guardada con éxito"
      end
    end
    render json: @result, status: :ok
  end
  #   #TODO delete this
  #   render :show
  #   return 0
  #   if !(params['origen'] && params['destino'] && params['monto']) then
  #     render_error('Params missing')
  #   else
  #     @transaction = Transaction.create(transaction_params)
  #     if @transaction.save then
  #       params[:id] = @transaction.id
  #       render :show
  #     else
  #       render_error('Transaction was not done')
  #     end
  #   end
  # end

  def obtenerCuenta
    pathdev = "https://integracion-2017-dev.herokuapp.com/bodega/fabrica/getCuenta"
    pathprod = "https://integracion-2017-prod.herokuapp.com/bodega/fabrica/getCuenta"
    auth = Crypt.generarauth("GET")
    puts auth
    headers = {'Content-type' => 'application/json', 'Authorization' => auth}
    params = {}
    @result = HTTParty.get(pathdev, :headers => headers)
    cuenta = JSON.parse(@result.response.body)
    puts cuenta["cuentaId"]
    return cuenta["cuentaId"]
  end


  def show
    @transaction = Transaction.find_by_id(params[:id])
    if @transaction || TRUE then
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
