Rails.application.routes.draw do

  resources :ware_houses
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root 'dashboard#index'
  #API
  namespace :api do
    get '/', to:  'application#index'
    #precios y stock por requerimiento de sprint
    get '/publico/precios',to: 'products#publico'
    #test
    post '/producir', to: 'factory#prodForced'
    get '/cleanStorage', to: 'ware_houses#cleanStorage'

    post '/fabricar', to: 'ware_houses#fabricar'

    get '/hash', to: 'application#hash'

    #Products
    get '/products', to: 'products#index'

    #Purchase order
    #show
    get '/purchase_orders/:id', to:'purchase_orders#obtener'
    #recibir
    put '/purchase_orders/:id', to: 'purchase_orders#recibir'
    #accept
    post '/purchase_orders/:id/accept', to: 'purchase_orders#accept'
    #reject
    post '/purchase_orders/:id/reject', to: 'purchase_orders#reject'
    #cancel
    delete '/purchase_orders/:id/cancel', to: 'purchase_orders#cancel'
    #crear OC experimentales
    #put '/purchase_orders/', to:'purchase_orders#testMovement'
    #put '/purchase_orders/', to:'purchase_orders#comprar'

    #Transfers
    #Transfer money
    put '/trx', to: "transactions#transfer"
    #show transaction
    get '/trx/:id', to: 'transactions#show'
    #get Account Statement
    post '/cartola', to:'transactions#accStatement'

    #Balance
    get '/banco/cuenta/:id', to:'balances#accBalance'

    #Invoice
    put '/invoices/:id', to:'invoices#create'
    get '/invoices/:id', to:'invoices#show'
    patch '/invoices/:id/accepted', to:'invoices#accept'
    patch '/invoices/:id/rejected', to:'invoices#reject'
    patch '/invoices/:id/delivered', to:'invoices#delivered'
    patch '/invoices/:id/paid', to:'invoices#paid'
    delete '/invoices/:id/cancel', to:'invoices#cancel'

    #WareHouse
    #show
    get '/almacenes', to: 'ware_houses#index'
    #get Products by sku
    get '/skusWithStock', to: 'ware_houses#skus_with_stock'
    #get getStock
    get '/stock', to: 'ware_houses#stock'
    #mover stock
    post '/moveStock', to: 'ware_houses#moveStock'


  end
end
