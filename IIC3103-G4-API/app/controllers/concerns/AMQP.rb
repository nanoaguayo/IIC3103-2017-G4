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
      #TODO crear Oferta en modelo
      puts json
    end

    conn.close
  end

end
