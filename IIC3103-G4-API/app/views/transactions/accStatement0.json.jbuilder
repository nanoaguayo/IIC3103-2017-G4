json.transactions @transactions do |trans|
  json.amount trans.amount
  json.originAccount trans.originAccount
  json.destinationAccount trans.destinationAccount
end
json.total @transactions.count
