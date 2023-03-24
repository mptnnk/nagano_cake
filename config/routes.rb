Rails.application.routes.draw do

  devise_for :admin,skip:[:registrations,:passwords],controllers:{
    sessions:'admin/sessions',
  }

  devise_for :customers,skip:[:passwords],controllers:{
    sessions:'public/sessions',
    registrations:'public/registrations'
  }

  scope module: :public do
    # controller:homes
    root to:'homes#top'
    get '/about'=>'homes#about',as:"about"
    
    # controller:customers
    get '/customers/my_page'=>'customers#show'
    get '/customers/information/edit'=>'customers#edit'
    patch 'customers/information'=>'customers#update'
    get '/customers/unsubscribe'=>'customers#unsubscribe'
    patch '/customers/withdraw'=>'customers#withdraw'

    # controller:addresses
    resources:addresses,only:[:index,:edit,:create,:update,:destroy]

    # controller:items
    resources:items,only:[:index,:show]

    # controller:cart_items
    resources:cart_items,only:[:index,:update,:destroy,:create]
    delete '/cart_items/destroy_all'=>'cart_items#destroy_all'

    # controller:orders
    resources:orders,only:[:new,:create,:index,:show]
    post '/orders/confirm'=>'orders#confirm'
    get '/orders/thanks'=>'orders#thanks'
  end

  namespace :admin do
    get '/'=>'homes#top'
    resources:customers,only:[:index,:show,:edit,:update]
    resources:items,only:[:index,:new,:create,:show,:edit,:update]
    resources:genres,only:[:index,:create,:edit,:update]
    resources:orders,only:[:show,:update]
    resources:order_details,only:[:update]
  end

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end