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
      #Ver si es valida para nosotros
      i = (json["inicio"]/1000)
      f = (json["fin"]/1000)
      inicio = Time.at(i)
      fin = Time.at(f)   
      if !Spree::Variant.where(sku:json['sku'].to_s).empty? then
        if Spree::Oferta.where(["inicio = ? and fin= ? and sku = ? and precio = ?",inicio,fin,json['sku'],Integer(json['precio'])]).empty? then
          of = Spree::Oferta.create(sku:json['sku'],precio:json['precio'],inicio:inicio,fin:fin,codigo:json['codigo'],publicar:json['publicar'])
          of.save
          puts of
        end
      end
    end

    conn.close
  end


end
