class DashboardController < ApplicationController
  OC_URI = Rails.env.development? && "http://integracion-2017-dev.herokuapp.com/oc/obtener/" || Rails.env.production? && "http://integracion-2017-prod.herokuapp.com/oc/obtener/"
  def index
    @almacenes = Fetcher.Bodegas("GET","almacenes")
    @productos = Hash.new 0
    @prod_names = Hash.new 0
    for almacen in @almacenes do
      id = almacen['_id']
      resp = Fetcher.Bodegas("GET"+id,"skusWithStock?almacenId="+id)
      for aux in resp do
        if @prod_names[aux['_id']] == 0 then
          aux2 = Product.where(sku:aux['_id']).first.description
          @prod_names[aux['_id']] = aux2
        end
        @productos[aux['_id']] = @productos[aux['_id']] + aux['total']
      end
    end

    #Chart
    @row_data = Array.new(@productos.count)
    index = 0
    for prod in @productos.keys do
      name = Product.where(sku:prod).first.description
      @row_data[index] = [name,@productos[prod]]
      index = index +1
    end

    #Produced orders
    @orders = ProducedOrder.all.reverse.first(20)

    #Spree orders
    so = Spree::Order.all
    @completed = so.find{|so| so.state=='complete'}
    if !@completed then
      @completed = Array.new
    end
    @uncompleted = so-@completed

    #FTP orders
    @ftp_requested = Ftp.GetOC()
    @ftp_status = Hash.new "0"
    for fo in @ftp_requested do
      aux =  HTTParty.get(OC_URI+fo[:id], :body => {}, :header => {'Content-type' => 'application/json'})
      @ftp_status[fo[:id].to_s] = aux[0]["estado"]
    end
  end
end
