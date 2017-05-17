require 'rails/all'
require 'openssl'
require "base64"
require 'httparty'

module Crypt
  # include HHTParty

  def self.sha1(str)
    Digest::SHA1.hexdigest str.to_s
  end

##Hasheo
  def self.encryptdev(data)
    #Clave bodega dev
    key = "z8t4GLUa:TKt0HK"
    _hash = Base64.encode64(OpenSSL::HMAC.digest(OpenSSL::Digest.new('sha1'),key,data)).strip()
    return _hash
  end

  def self.encryptprod(data)
    #Clave bodega prod
    key = "vTvHgY0Cu&RsQrV"
    _hash = Base64.encode64(OpenSSL::HMAC.digest(OpenSSL::Digest.new('sha1'),key,data)).strip()
    return _hash
  end

  def self.generarauthdev(data)
    _hash = encryptdev(data)
    _hash = "INTEGRACION grupo4:" + _hash
    return _hash
  end

  def self.generarauthprod(data)
    _hash = encryptprod(data)
    _hash = "INTEGRACION grupo4:" + _hash
    return _hash
  end


  # def self.decrypt(text, key='')
  #   _hash = Base64.decode64(OpenSSL::HMAC.digest(OpenSSL::Digest.new('sha1'),key,text)).strip()
  #   return _hash
  # end
end

# CloudFlare "aware" IP get
# class ActionController::Request
#   def encrypt(data)
#     Crypt.encrypt(data, (headers["CF-Connecting-IP"] || remote_ip))
#   end
#
#   def decrypt(text)
#     Crypt.decrypt(text, (headers["CF-Connecting-IP"] || remote_ip))
#   end
# end
