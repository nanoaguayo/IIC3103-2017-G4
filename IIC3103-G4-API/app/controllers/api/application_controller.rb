require 'json'
require 'net/http'
require 'base64'
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

  def hash
    #POR EJEMPLO encriptar string "GET" y generar auth para request bodegas
    ret = Crypt.generarauthdev("GET")
    render json: ret, status: :ok
  end



end
