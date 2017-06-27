require "bunny"

module AMQP
  #Connect to AMQP
  URL = Rails.env.development? && "amqp://vqlvjyqw:075Ksv_di31QLxHOQ3dSHZ-krWmo9G6y@fish.rmq.cloudamqp.com/vqlvjyqw" || Rails.env.production? && "amqp://iwddapan:yut9wcbCeW9KaxLSG-ruEmRKxvO2t7my@fish.rmq.cloudamqp.com/iwddapan"

  def self.updateOffers
    conn = Bunny.new(URL)
    conn.start

    ch = conn.create_channel
    q  = ch.queue("ofertas", :auto_delete => true)

    q.subscribe do |delivery_info, metadata, payload|
      json = payload.to_json
      puts json
      #Ver si es valida para nosotros
      if Product.where(sku:json['sku']).first then
        #TODO crear Oferta en modelo
        #TODO ver bien las keys
        #Spree::Oferta.create(sku:json['sku'],precio:json['precio'],inicio:Date(json['inicio']),fin:Date(json['fin']),codigo:json['codigo'],publicar:json['publicar'])
      end
    end

    conn.close
  end

  def self.TestSpree
    aux = Spree::Promotion.create(
      description:'test',
      expires_at:Time.new('10-10-2017'),
      starts_at:Time.new,
      name:'Testing',
      code:'promo1',
      match_policy: 'all',
      usage_limit: '10000'
    )
    rule = Spree::Promotion::Rules::Product.create({
      promotion: aux
    })
    promotion.promotion_actions << Spree::Promotion::Actions::CreateAdjustment.create({
        calculator: Spree::Calculator::FlatRate.new(preferred_amount: 30)
      })
    return aux
  end

end
