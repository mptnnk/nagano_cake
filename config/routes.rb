Rails.application.routes.draw do
  
  devise_for :admins,controllers:{
    sessions:'admin/sessions',
    passwords:'admin/passwords',
    registrations:'admin/registrations'
  }
  
  devise_for :customers,controllers:{
    sessions:'public/sessions',
    passwords:'public/passwords',
    registrations:'public/registrations'
  }
  
  scope module: :public do
    root to:'homes#top'
    get '/about'=>'homes#about',as:"about"
    # controller:customers
    get '/customers/my_page'=>'customers#show'
    get '/customers/information/edit'=>'customers#edit'
    patch 'customers/information'=>'customers#update'
    get '/customers/unsbscribe'=>'customers#unsubsribe'
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
    get '/'=>'homes#top',as:"admin"
    resources:customers,only:[:index,:show,:edit,:update]
    resources:items,only:[:index,:new,:create,:show,:edit,:update]
    resources:genres,only:[:index,:create,:edit,:update]
    resources:orders,only:[:show,:update]
    resources:order_details,only:[:update]
  end
  
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end