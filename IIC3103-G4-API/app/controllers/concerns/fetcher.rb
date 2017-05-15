require 'httparty'
HTTParty::Basement.default_options.update(verify: false)

module Fetcher

  BODEGA_URI = Rails.env.development? && "https://integracion-2017-dev.herokuapp.com/bodega/" || Rails.env.production? && "https://integracion-2017-prod.herokuapp.com/bodega/"

  def self.Bodegas(httpRequest,uri_ext)
    auth = Crypt.generarauthdev(httpRequest)
    if Rails.env.production? then
      auth = Crypt.generarauthprod(httpRequest)
    end
    options = {'Content-type' => 'application/json', 'Authorization' => auth}
    response = HTTParty.get(BODEGA_URI+uri_ext,headers: options)
    puts response
  end

end
