class TransactionsController < ApplicationController


  def show
    id = params[:id]
    render json: Banco.obtenerTransferencia(id).body
    #render json: Banco.transfer(1,'⁠⁠⁠590baa00d6b4ec0004902472').body
  end

  def showCuenta
    id = params[:id]
    render json: Banco.obtenerCuentaGrupo(id).body
  end

end
