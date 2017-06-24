require 'twitter'
require 'koala'

CLIENTTWITTER = Twitter::REST::Client.new do |config|
  config.consumer_key        = "8pBG4kslpZWQ33W8UcZrZenNr"
  config.consumer_secret     = "WbZKNxzhgzvtT336fVmHJHok0MeVdUkm7UiJYQRLRDa1fNgi0O"
  config.access_token        = "878336462286139392-uOIKivxPiylhWxtq1OhxkDMO7vgnMgK"
  config.access_token_secret = "BlAOM5yVNsvMtzCjzk5tanREU28a5UJqIDKoN1cfp7EIq"
end

Koala.configure do |config|
  config.access_token = "EAAIAUd42WqYBALaamio0x7Qq019eacdGpMC1e7VOFGefw1TnwLZBcBN3B9LMV3IUzU7RXf7wi1fyQpYmraTdDGCpnK3A9IrjyMxGN6C3CeMAr0RGCLzxycxlSkI62dYMjFT2UKvcilgYyw1rLZBRWm4UiPcqas6KbxjLRz7BbqvVZBYuoi0erbZBjO4FSTQZD"
  config.app_access_token = "EAAIAUd42WqYBANOkRoaKrIuiATQZCZAadSgTSZCDWZBWZBKbQBcOjzkG0YhmMEG4asOcA1eUgCOKQpcuzhIVjTNKF1EAow3XccxvLbQydchSEs56xeMUALLpzdQahAev2U6kdTSob5dUaUliiNAA4KDZCdWZBo4Y2gZBmyOmbWjOW2mQ2T3MTDX8F5pOJdDD18oZD"
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

    @page_graph = Koala::Facebook::API.new("EAAIAUd42WqYBANOkRoaKrIuiATQZCZAadSgTSZCDWZBWZBKbQBcOjzkG0YhmMEG4asOcA1eUgCOKQpcuzhIVjTNKF1EAow3XccxvLbQydchSEs56xeMUALLpzdQahAev2U6kdTSob5dUaUliiNAA4KDZCdWZBo4Y2gZBmyOmbWjOW2mQ2T3MTDX8F5pOJdDD18oZD")

    @page_graph.get_object('me') # I'm a page
    @page_graph.get_connection('me', 'feed') # the page's wall
    @page_graph.put_wall_post(post)

  end

end
