require 'httparty'

module Shopping

  #Ejemplo: Shopping.comprar("1","45","20","100","prueba",1506135600000)
  def self.comprar(proveedor,sku,cantidad,precio,comments,fechaE)

    path = "http://integracion-2017-dev.herokuapp.com/oc/crear"
    puts path
    header = {"Content-Type" => "application/json"}
    params = {
      "cliente": "590baa00d6b4ec0004902465", # nuestro dev grupo 4
      "proveedor": "590baa00d6b4ec0004902462", # dev grupo 1
      "sku": sku,
      "fechaEntrega": fechaE,
      "cantidad": cantidad,
      "precioUnitario": precio,
      "canal": "b2b",
      "notas": comments
    }
    @result = HTTParty.put(path, :body => params, :header => header)
    case @result.code
      when 200
        puts "ENTROOOOOOOOOOOOOO"
        @ordenc = JSON.parse(@result.response.body)

        @purchase_order = PurchaseOrder.new(@ordenc)
        if @purchase_order.save then
          puts "Guardada con éxito"
        end
    end
    return @result
  end


end
