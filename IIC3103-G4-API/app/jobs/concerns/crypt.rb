require 'rails/all'
require 'openssl'
require "base64"
require 'httparty'

module Crypt
  # include HHTParty

  #def self.sha1(str)
   # Digest::SHA1.hexdigest str.to_s
  #nd

  def self.generarauth(data)
    _hash = Base64.encode64(OpenSSL::HMAC.digest(OpenSSL::Digest.new('sha1'),KEY,data)).strip()
    _hash = "INTEGRACION grupo4:" + _hash
    return _hash
  end
end
