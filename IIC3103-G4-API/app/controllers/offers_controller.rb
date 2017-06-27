class OffersController < ApplicationController
  def getOffers
    AMQP.updateOffers()
  end
end
