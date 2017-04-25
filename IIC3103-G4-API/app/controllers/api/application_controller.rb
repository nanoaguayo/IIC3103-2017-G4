class Api::ApplicationController < ActionController::API

  def render_error(error)
    render status: 500, json:{
      Error: error
    }
  end

  def index
    render json: {
      api: 'v1',
      group:"Group 4"
    }
  end
end
