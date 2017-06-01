every :hour do # Many shortcuts available: :hour, :day, :month, :year, :reboot
  runner "Products#updateStock"
end
