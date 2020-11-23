Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  root to: "products#index"

  get '/products/explore', to: 'products#explore', as: 'explore'
  post '/products/:id/add_to_cart', to: 'products#add_to_cart', as: 'add_to_cart'
  post '/products/retire/:id', to: 'products#retire', as: 'retire'
  resources :products do
    resources :reviews, only: [:create, :new]
  end


  resources :users, only: [:index, :show, :edit]
  get '/users/id/user_account', to: 'users#user_account', as: 'user_account'
  get '/users/id/order_history', to: 'users#order_history', as: 'order_history'
  get '/users/id/manage_tours', to: 'users#manage_tours', as: 'manage_tours'

  get '/orders/shopping_cart', to: 'orders#shopping_cart', as: 'shopping_cart'
  get '/orders/id/submit', to: 'orders#submit', as: 'order_submit'
  resources :orders, except: [:new]
  resources :order_items, except: [:index, :show, :new]
  # resources :reviews, only: [:new]
  resources :payment_infos, except: [:index, :show]
  resources :categories


  get "/auth/github", as: "github_login"
  get "/auth/:provider/callback", to: "users#create"
  delete "/logout", to: "users#destroy", as: "logout"

end
