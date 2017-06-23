require 'twitter'

CLIENT = Twitter::REST::Client.new do |config|
  config.consumer_key        = "8pBG4kslpZWQ33W8UcZrZenNr"
  config.consumer_secret     = "WbZKNxzhgzvtT336fVmHJHok0MeVdUkm7UiJYQRLRDa1fNgi0O"
  config.access_token        = "878336462286139392-uOIKivxPiylhWxtq1OhxkDMO7vgnMgK"
  config.access_token_secret = "BlAOM5yVNsvMtzCjzk5tanREU28a5UJqIDKoN1cfp7EIq"
end

module Socialnet

  def self.Twittear(twit)
    CLIENT.update(twit)
  end

end
