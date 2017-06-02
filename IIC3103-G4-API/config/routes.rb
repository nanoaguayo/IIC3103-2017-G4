Rails.application.routes.draw do

  resources :ware_houses
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  require 'sidekiq/web'
  mount Sidekiq::Web => '/sidekiq'

  #precios y stock por requerimiento de sprint


  #Spree starting in /store URL
  mount Spree::Core::Engine, at: '/store'
  get '/' => redirect('/store')
  #Dashboard
  get '/dashboard', to: 'dashboard#index'


  #Tickets
  get '/ticket_accepted', to: 'ticket#accepted'
  get '/ticket_decline', to: 'ticket#decline'

  patch '/ticket', to:'ticket#new'


  #precios y stock por requerimiento de sprint
  get 'api/publico/precios',to: 'products#publico'
  #test
  post 'api/producir', to: 'factory#prodForced'
  get 'api/cleanStorage', to: 'ware_houses#cleanStorage'

  post 'api/fabricar', to: 'ware_houses#fab'

  get 'api/hash', to: 'application#hash'

  #Products
  get '/products', to: 'products#index'

  #Purchase order
  #show
  get 'api/purchase_orders/:id', to:'purchase_orders#obtener'
  #recibir
  put 'api/purchase_orders/:id', to: 'purchase_orders#recibir'
  #accept
  post 'api/purchase_orders/:id/accept', to: 'purchase_orders#accept'
  #reject
  post 'api/purchase_orders/:id/reject', to: 'purchase_orders#reject'
  #cancel
  delete 'api/purchase_orders/:id/cancel', to: 'purchase_orders#cancel'
  post '/purchase_orders/comprar', to: 'purchase_orders#ComprarPostman'
  #crear OC experimentales
  #put '/purchase_orders/', to:'purchase_orders#testMovement'
  #put '/purchase_orders/', to:'purchase_orders#comprar'

  #Transfers
  #Transfer money
  put 'api/trx', to: "transactions#transfer"
  #show transaction
  get 'api/trx/:id', to: 'transactions#show'
  #get Account Statement
  post 'api/cartola', to:'transactions#accStatement'

  #Balance
  get 'api/banco/cuenta/:id', to:'balances#accBalance'

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
  get 'api/almacenes', to: 'ware_houses#index'
  #get Products by sku
  get 'api/skusWithStock', to: 'ware_houses#skus_with_stock'
  #get getStock
  get 'api/stock', to: 'ware_houses#stock'
  #mover stock
  post 'api/moveStock', to: 'ware_houses#moveStock'

end
