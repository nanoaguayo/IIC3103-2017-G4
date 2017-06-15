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

  #Test FTP
  get '/ftp', to: 'purchase_orders#checkFTP'

  #Tickets
  get '/ticket_accepted', to: 'ticket#accepted'
  get '/ticket_decline', to: 'ticket#decline'

  patch '/ticket', to:'ticket#new'


  #precios y stock por requerimiento de sprint
  get 'api/publico/precios',to: 'products#publico'
  #test
  post 'producir', to: 'factory#prodForced'
  get 'cleanStorage', to: 'ware_houses#cleanStorage'

  post 'fabricar', to: 'ware_houses#fab'

  get 'hash', to: 'application#hash'

  #Products
  get '/products', to: 'products#index'

  #Purchase order
  #show
  get '/purchase_orders/:id', to:'purchase_orders#obtener'
  #recibir
  #realizar_pedido: Crea una notificación de que se nos hizo una orden de compra. Debe tener el id de la orden de compra, el método de pago (puede ser contra factura o contra despacho) y el id de la bodega.
  put '/purchase_orders/:id', to: 'purchase_orders#recibir'
  #accept
  #confirmar_orden_compra: Crea una notificación de aceptación de la orden de compra generada por nosotros. Debe tener el id de la orden de compra.
  patch '/purchase_orders/:id/accepted', to: 'purchase_orders#accept'
  #reject
  #rechazar_orden_compra: Crea una notificación de rechazo de la orden de compra generada por nosotros. Debe tener el id de la orden de compra.
  patch '/purchase_orders/:id/rejected', to: 'purchase_orders#reject'
  #cancel
  delete '/purchase_orders/:id/cancel', to: 'purchase_orders#cancel'
  post '/purchase_orders/comprar', to: 'purchase_orders#ComprarPostman'
  #crear OC experimentales
  #put '/purchase_orders/', to:'purchase_orders#testMovement'
  #put '/purchase_orders/', to:'purchase_orders#comprar'

  #Transfers
  #Transfer money
  put 'trx', to: "transactions#transfer"
  #show transaction
  get 'trx/:id', to: 'transactions#show'
  #get Account Statement
  post 'cartola', to:'transactions#accStatement'

  #Balance
  get 'banco/cuenta/:id', to:'balances#accBalance'

  #Invoice
  #enviar_factura: Crea una notificación de habernos emitido una factura. Debe tener el id de la factura y la cuenta del banco.
  put 'invoices/:id', to:'invoices#create'
  #enviar_confirmacion_factura: Crea una notificación de que no se rechazará la factura enviada. Debe tener el id de la factura
  patch 'invoices/:id/accepted', to:'invoices#accept'
  #enviar_rechazo_factura: Crea una notificación de que se rechaza la factura enviada. Debe tener el id de la factura.
  patch 'invoices/:id/rejected', to:'invoices#reject'
  #notificar_orden_despachada: Notificar para cambiar de estado de una factura. Debe tener el id de la factura.
  patch 'invoices/:id/delivered', to:'invoices#delivered'
  #enviar_confirmacion_pago: Crea una notificación de que se pagó la factura. Debe tener el id de la factura.
  patch 'invoices/:id/paid', to:'invoices#paid'
  get 'invoices/:id', to:'invoices#show'

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
