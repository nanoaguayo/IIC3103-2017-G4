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

    #Invoice

    #Payment
    
  end
end
