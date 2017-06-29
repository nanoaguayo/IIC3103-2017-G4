class Spree::Oferta < ApplicationRecord
  def self.getOffers
    AMQP.updateOffers()
  end

  def self.publishOffers
    if Rails.env.production? then
      aux = Spree::Oferta.all
      for offer in aux do
        if offer.inicio.past? && !offer.fin.past? && offer.publicar then
          prod = Product.where(sku:Integer(offer.sku)).first
          str = "No te pierdas nuestra oferta!" + prod.description + "(SKU:"+offer.sku+ ")a precio oferta de $"+ offer.precio + "Solo ingresa el siguiente codigo de dcto:" + offer.codigo
          Socialnet.Twittear(str)
          SocialNet.Postear(str)
          offer.publicar = False
          offer.save
        end
      end
    end
  end
  
end
