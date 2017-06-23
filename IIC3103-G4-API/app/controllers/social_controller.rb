class SocialController < ApplicationController

  def index
  end

  def twittear

    twit = params[:twit]
    Socialnet.Twittear(twit)

  end

end
