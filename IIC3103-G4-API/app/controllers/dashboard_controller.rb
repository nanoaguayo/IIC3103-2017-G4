class DashboardController < ApplicationController
  def index
    @almacenes = Fetcher.Bodegas("GET","almacenes")
    @productos = Hash.new 0
    for almacen in @almacenes do
      id = almacen['_id']
      resp = Fetcher.Bodegas("GET"+id,"skusWithStock?almacenId="+id)
      puts resp
      for aux in resp do
        @productos[aux['_id']] = @productos[aux['_id']] + aux['total']
      end
    end

    @row_data = Array.new(@productos.count)
    index = 0
    for prod in @productos.keys do
      puts prod
      @row_data[index] = [prod,@productos[prod]]
      index = index +1
    end

    @orders = ProducedOrder.all.reverse.first(20)

    #Spree orders
    so = Spree::Order.all
    puts so.inspect
    @completed = so.find{|so| so.state=='complete'}
    if !@completed then
      @completed = Array.new
    end
    puts @completed.inspect
    @uncompleted = so-@completed
    puts @uncompleted.inspect
  end
end
