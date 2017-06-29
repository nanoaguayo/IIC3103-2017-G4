
class Invoice < ApplicationRecord
  PATH = Rails.env.development? && "http://integracion-2017-dev.herokuapp.com/sii/" || Rails.env.production? && "https://integracion-2017-prod.herokuapp.com/sii/"

  def self.crear(oc)
    header = {"Content-Type" => "application/json"}
    params = {
      "oc": oc
    }
    @result = HTTParty.put(PATH, :body => params, :header => header)
    case @result.code
    when 200
      @fact = JSON.parse(@result.response.body)
      @fact["oc"] = @fact["oc"]["_id"]
      @invoice = Invoice.new(@fact)
      if @invoice.save then
        puts "Guardada con éxito"
      end
    end
    #render json: @fact, status: :ok
    return @result
  end

end
