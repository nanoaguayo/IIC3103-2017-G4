require 'rails/all'
require 'openssl'
require "base64"
require 'httparty'

module CryptJobs
  # include HHTParty

  #def self.sha1(str)
   # Digest::SHA1.hexdigest str.to_s
  #nd
  KEYj = Rails.env.development? && "z8t4GLUa:TKt0HK" || Rails.env.production? && "vTvHgY0Cu&RsQrV"

  def self.generarauth(data)
    _hash = Base64.encode64(OpenSSL::HMAC.digest(OpenSSL::Digest.new('sha1'),KEYj,data)).strip()
    _hash = "INTEGRACION grupo4:" + _hash
    return _hash
  end
end
