class DispatchOcJob < ApplicationJob
  queue_as :default

  def perform(id) #se recibe el id de la Orden que se quiere despachar (2do modelo para ocs)
    oc = Order.find_by(id: id)
    oc.update(state: "processing") #se marca la orden como que se está moviendo, para que no se muevan otras
    FetcherJob.moveToDespacho(oc.sku, oc.total)
    if oc.destination == "FTP"
      FetcherJob.despacharFtp(oc.sku, oc.total, oc.destination, oc.oc)
    else
      FetcherJob.moveToGroup(oc.sku, oc.total, oc.destination, oc.oc)
    end
    oc.update(state: "finished") #se marca como terminada para poder mover otras
  end
end
