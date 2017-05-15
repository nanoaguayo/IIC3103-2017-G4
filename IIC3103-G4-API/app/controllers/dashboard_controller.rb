class DashboardController < ApplicationController
  def index
    @almacenes = [{
         "_id": "4af9f23d8ead0e1d32000000",
         "usedSpace": 100,
         "totalSpace": "10000",
         "recepcion": false,
         "despacho": false,
         "pulmon": false,
         "grupo": 4
      },{
         "_id": "4af9f23d8ead0e1d32000a00",
         "usedSpace": 0,
         "totalSpace": "99000",
         "recepcion": true,
         "despacho": false,
         "pulmon": false,
         "grupo": 4
      },{
         "_id": "4af9f23d8ead0e1d320f0a00",
         "usedSpace": 0,
         "totalSpace": "99999999",
         "recepcion": false,
         "despacho": false,
         "pulmon": true,
         "grupo": 4
      },{
         "_id": "4af9f24d8ead0e1d320f0a00",
         "usedSpace": 60,
         "totalSpace": "900",
         "recepcion": false,
         "despacho": true,
         "pulmon": false,
         "grupo": 4
    }]
    @productos = [{
       "_id": {
          "sku": 1
        },
        "total": 53
    },{
       "_id": {
          "sku": 32
        },
        "total": 3
    },{
       "_id": {
          "sku": 34
        },
        "total": 870
    }]
    @row_data = Array.new(@productos.count)
    index = 0
    for prod in @productos do
      puts prod
      @row_data[index] = [prod[:_id][:sku],prod[:total]]
      index = index +1
    end
  end
end
