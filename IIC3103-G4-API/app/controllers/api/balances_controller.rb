class Api::BalancesController < Api::ApplicationController
  
  def accBalance
      balance = Balance.find_by_id(params[:id])
      if balance then
        render json: {
          amount: balance.amount
        }
      else
        render_error('Account not found')
      end
  end
end
