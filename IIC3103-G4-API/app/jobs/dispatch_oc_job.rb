class DispatchOcJob < ApplicationJob
  queue_as :default

  def perform(id)
    Order.find_by(id: id).update(state: "processing") #se marca la orden como que se está moviendo, para que no se muevan otras
    
    Order.find_by(id: id).update(state: "finished") #se marca como terminada para poder mover otras
  end
end
