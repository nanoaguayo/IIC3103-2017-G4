require 'net/ftp'

USER = "grupo4"
PASS = Rails.env.development? && "GMChbrR2Y6mFzacu" || Rails.env.production? && "p6FByxRf5QYbrDC8"
PORT = 22
SERVER = Rails.env.development? && "integra17dev.ing.puc.cl" || Rails.env.production? && "integra17.ing.puc.cl"

module Ftp

  def self.GetOC
    ftp = Net::FTP.new
    ftp.passive = true
    ftp.connect(SERVER,PORT)
    ftp.login(USER,PASS)
    return ftp.list('./')
  end

end
