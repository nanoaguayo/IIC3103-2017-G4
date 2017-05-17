Rails.application.routes.draw do

  resources :ware_houses
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root 'dashboard#index'
  #API
  namespace :api do
    get '/', to:  'application#index'

    #test
    get '/testupdate', to: 'ware_houses#testMovement'
    post '/fabricar', to: 'ware_houses#fabricar'

    get '/hash', to: 'application#hash'

    #Products
    get '/products', to: 'products#index'

    #Purchase order
    #show
    get '/purchase_orders/:id', to:'purchase_orders#show'
    #create
    put '/purchase_orders/:id', to: 'purchase_orders#create'
    #accept
    patch '/purchase_orders/:id/accepted', to: 'purchase_orders#receive'
    #reject
    patch '/purchase_orders/:id/rejected', to: 'purchase_orders#reject'
    #cancel
    delete '/purchase_orders/:id', to: 'purchase_orders#cancel'

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
