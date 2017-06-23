every :hour do # Many shortcuts available: :hour, :day, :month, :year, :reboot
  runner "Products#updateStock"
end

every 6.hours do
  runner "PurchaseOrders#checkFTP"
end

every 10.minutes do
  runner "PurchaseOrders#CheckQueue"
end