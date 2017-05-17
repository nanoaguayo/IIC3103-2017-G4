json.message "Listado de almacenes"
json.almacenes @ware_houses do |wh|
  json.id wh.id
  json.usedspace wh.usedspace
  json.totalspace wh.totalspace
  json.recepcion wh.recepcion
  json.dispatch wh.dispatch
  json.pulmon wh.pulmon 
end
