class SocialController < ApplicationController

  def index
  end

  def social

    if params[:twit] then
      Socialnet.Twittear(params[:twit])
    end
    if params[:post] then
      Socialnet.Postear(params[:post])
    end
  end

end
