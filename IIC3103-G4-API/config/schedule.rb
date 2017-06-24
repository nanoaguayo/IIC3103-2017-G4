every :hour do # Many shortcuts available: :hour, :day, :month, :year, :reboot
  runner "Products#updateStock"
end

every 6.hours do
  runner "PurchaseOrders#checkFTP"
end

every 30.minutes do
  runner "WareHouses#clean" #que cada media hora se encole el job para limpiar las bodegas
  #total si están vacias no hace nada.
end

every 10.minutes do
  runner "PurchaseOrders#CheckQueue"
end