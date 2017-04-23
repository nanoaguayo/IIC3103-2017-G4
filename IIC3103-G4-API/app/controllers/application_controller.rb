class ApplicationController < ActionController::API
  def render_error(error)
    render status: 500, json:{
      Message: error
    }
  end
end
