class Api::BalancesController < Api::ApplicationController

  def accBalance
      balance = Balance.find_by_id(params[:id])
      if balance || TRUE then
        render json: {
          #amount: balance.amount
          amount: 10000
        }
      else
        render_error('Account not found')
      end
  end
end
