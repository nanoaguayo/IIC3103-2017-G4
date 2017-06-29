require "bunny"
require "json"

module AMQP
  #Connect to AMQP
  URL = Rails.env.development? && "amqp://vqlvjyqw:075Ksv_di31QLxHOQ3dSHZ-krWmo9G6y@fish.rmq.cloudamqp.com/vqlvjyqw" || Rails.env.production? && "amqp://iwddapan:yut9wcbCeW9KaxLSG-ruEmRKxvO2t7my@fish.rmq.cloudamqp.com/iwddapan"

  def self.updateOffers
    conn = Bunny.new(URL)
    conn.start

    ch = conn.create_channel
    q  = ch.queue("ofertas", :auto_delete => true)

    q.subscribe do |delivery_info, metadata, payload|
      json = JSON.parse(payload)
      puts json
      #Ver si es valida para nosotros
      if json && Spree::Product.where(sku:json['sku']).first then
        if Spree::Oferta.where(["inicio = ? and fin= ? and sku = ? and precio = ?",Date(json['inicio']),Date(json['fin']),json['sku'],Integer(json['precio'])]).empty? then
          of = Spree::Oferta.create(sku:json['sku'],precio:json['precio'],inicio:Date(json['inicio']),fin:Date(json['fin']),codigo:json['codigo'],publicar:json['publicar'])
          of.save
        end
      end
    end

    conn.close
  end


end
