#documentation: https://github.com/net-ssh/net-sftp

USER = "grupo4"
PASS = Rails.env.development? && "GMChbrR2Y6mFzacu" || Rails.env.production? && "p6FByxRf5QYbrDC8"
PORT = 22
SERVER = Rails.env.development? && "integra17dev.ing.puc.cl" || Rails.env.production? && "integra17.ing.puc.cl"

module Ftp

  def self.GetOC
    resp = Array.new
    count = 0
    Net::SFTP.start(SERVER,USER,password:PASS) do |con|
      con.dir.foreach("/pedidos") do |file|
        if file.file?() then
          file = con.download!("/pedidos/"+file.name)
          xml = Nokogiri::Slop(file)
          aux = {
            id: xml.order.id.content,
            sku: xml.order.sku.content,
            qty: xml.order.qty.content
          }
          resp[count] = aux
          count += 1
        end
      end
      return resp
    end
  end

end
