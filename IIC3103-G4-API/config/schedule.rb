# Use this file to easily define all of your cron jobs.
#
# It's helpful, but not entirely necessary to understand cron before proceeding.
# http://en.wikipedia.org/wiki/Cron

# Example:
#
# set :output, "/path/to/my/cron_log.log"
#
# every 2.hours do
#   command "/usr/bin/some_great_command"
#   runner "MyModel.some_method"
#   rake "some:great:rake:task"
# end
#
# every 4.days do
#   runner "AnotherModel.prune_old_records"
# end

# Learn more: http://github.com/javan/whenever
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

every 6.hours do
  runner "offers#updateOffers"
end
