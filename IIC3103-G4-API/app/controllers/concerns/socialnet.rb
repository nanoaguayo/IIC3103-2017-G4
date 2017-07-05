require 'twitter'
require 'koala'

CLIENTTWITTER = Twitter::REST::Client.new do |config|
  config.consumer_key        = "8pBG4kslpZWQ33W8UcZrZenNr"
  config.consumer_secret     = "WbZKNxzhgzvtT336fVmHJHok0MeVdUkm7UiJYQRLRDa1fNgi0O"
  config.access_token        = "878336462286139392-uOIKivxPiylhWxtq1OhxkDMO7vgnMgK"
  config.access_token_secret = "BlAOM5yVNsvMtzCjzk5tanREU28a5UJqIDKoN1cfp7EIq"
end

Koala.configure do |config|
  config.access_token = "EAAIAUd42WqYBAOCCLbQbd7ZC9f7J8DrDuFYLIR6zBQLkKZAXnu9xlA4EbZAXW3evuLJIDMeOkyYJg5FJrCM8MlUYMoDmo7oBUgV9fCaN4WS1G1cawuWPWCiRNBHUrAES5fZAo3EAdZAhGBUmVZClU8tZCPtDZCdy7ecZD"
  config.app_access_token = "EAAIAUd42WqYBAOCCLbQbd7ZC9f7J8DrDuFYLIR6zBQLkKZAXnu9xlA4EbZAXW3evuLJIDMeOkyYJg5FJrCM8MlUYMoDmo7oBUgV9fCaN4WS1G1cawuWPWCiRNBHUrAES5fZAo3EAdZAhGBUmVZClU8tZCPtDZCdy7ecZD"
  config.app_id = "563301573876390"
  config.app_secret = "d3e7d77f760febafa4536c0595891efe"
end

module Socialnet

#Twitter
  def self.Twittear(twit)
    CLIENTTWITTER.update(twit)
  end

#Facebook
  def self.Postear(post)

    access_token = "EAAIAUd42WqYBAOCCLbQbd7ZC9f7J8DrDuFYLIR6zBQLkKZAXnu9xlA4EbZAXW3evuLJIDMeOkyYJg5FJrCM8MlUYMoDmo7oBUgV9fCaN4WS1G1cawuWPWCiRNBHUrAES5fZAo3EAdZAhGBUmVZClU8tZCPtDZCdy7ecZD"
    @graph = Koala::Facebook::API.new(access_token)
		pages = @graph.get_connections('me', 'accounts')
		first_page_token = pages.first['access_token']
		@page_graph = Koala::Facebook::API.new(first_page_token)
    @page_graph.get_object('me') # I'm a page
    @page_graph.get_connection('me', 'feed') # the page's wall
    @page_graph.put_wall_post(post)

  end

end
