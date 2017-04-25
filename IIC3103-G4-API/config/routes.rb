Rails.application.routes.draw do

  resources :ware_houses
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root 'api#index'
  #API
  namespace :api do
    get '/', to:  'application#index'

    #Products
    get '/products', to: 'products#index'

    #Purchase order
    #show
    get '/obtener/:id', to:'purchase_orders#show'
    #create
    put '/crear', to: 'purchase_orders#create'
    #accept
    post '/recepcionar/:id', to: 'purchase_orders#receive'
    #reject
    post '/rechazar/:id', to: 'purchase_orders#reject'
    #cancel
    delete '/anular/:id', to: 'purchase_orders#cancel'

    #Bank
    #Transfer money
    put '/trx', to: "bank#transfer"
    #show transaction
    get '/trx:id', to: 'bank#show_transaction'
    #get Account Statement
    post '/cartola', to:'bank#accStatement'
    #get account balance
    get '/banco/cuenta/:id', to:'bank#accBalance'

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
