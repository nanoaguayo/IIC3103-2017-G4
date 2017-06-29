class WareHouse < ApplicationRecord

  def self.cleanStorage
      almacenes = Fetcher.Bodegas("GET","almacenes")
      id_pulmon = ""
      id_recepcion = ""
      otherStorages = Hash.new 0
      for alm in almacenes do
        if alm['pulmon'] && (Integer(alm['usedSpace']) > 0) then
          id_pulmon = alm['_id']
        elsif alm['recepcion'] && (Integer(alm['usedSpace']) > 0) then
          id_recepcion = alm['_id']
        elsif !alm['recepcion'] && !alm['pulmon'] && !alm['despacho'] && (Integer(alm['totalSpace']) - Integer(alm['usedSpace'])>0) then
          otherStorages[alm['_id']] = Integer(alm['totalSpace']) - Integer(alm['usedSpace'])
        end
      end
      #Loop to clean all, first recepcion
      if id_recepcion != "" then
        prods = Fetcher.Bodegas("GET"+id_recepcion.to_s,"skusWithStock?almacenId="+id_recepcion.to_s)
        for prod in prods do
          #get products in storage for each sku
          puts prod
          prodList = Fetcher.Bodegas("GET"+id_recepcion.to_s+prod['_id'].to_s,"stock?almacenId="+id_recepcion.to_s+"&sku="+prod['_id']+"&limit=200")
          puts prodList
          count = 3
          while prodList.count > 0 do
            aux = prodList.pop
            for key in otherStorages.keys do
              if otherStorages[key]>0 then
                moveStock(aux['_id'].to_s,key)
                otherStorages[key] = otherStorages[key]-1
                break
              end
            end
            if count == 89 then
                count = 0
                sleep(60)
            end
            if prodList.count == 0 then
                prodList = Fetcher.Bodegas("GET"+id_recepcion.to_s+prod['_id'].to_s,"stock?almacenId="+id_recepcion.to_s+"&sku="+prod['_id']+"&limit=200")
                count = count + 1
            end
            count = count + 1
          end
        end
      end
      #Move to dispatch storage frm pulmon
      if id_pulmon != "" then
        prods = Fetcher.Bodegas("GET"+id_pulmon.to_s,"skusWithStock?almacenId="+id_pulmon.to_s)
        for prod in prods do
          #get products in storage for each sku
          puts prod
          prodList = Fetcher.Bodegas("GET"+id_pulmon.to_s+prod['_id'].to_s,"stock?almacenId="+id_pulmon.to_s+"&sku="+prod['_id']+"&limit=200")
          count = 3
          while prodList.count > 0 do
            aux = prodList.pop
            moveStock(aux['_id'].to_s,id_recepcion)
            if count == 89 then
                count = 0
                sleep(60)
            end
            if prodList.count == 0 then
                prodList = Fetcher.Bodegas("GET"+id_pulmon.to_s+prod['_id'].to_s,"stock?almacenId="+id_pulmon.to_s+"&sku="+prod['_id']+"&limit=200")
                count = count + 1
            end
            count = count + 1
          end
        end
      end
  end
end
