Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root 'api#index'
  #API
  namespace :api do
    get '/', to:  'application#index'

    #Products
    get '/products', to: 'products#index'

    #Purchase order
    put '/purchase_order', to: 'purchase_orders#create'
    #TODO: accept and delete

    post '/recepcionar/:id', to: 'purchase_orders#receive' , defaults: {format: :json}

    post '/rechazar/:id', to: 'purchase_orders#reject'

    delete '/anular/:id', to: 'purchase_orders#cancel'

    get '/obtener/:id', to: 'purchase_orders#get'

    #Invoice

    #Payment

  end
end
