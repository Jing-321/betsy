Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  root to: "products#index"
  ##########products
  get '/products/explore', to: 'products#explore', as: 'explore'
  post '/products/:id/add_to_cart', to: 'products#add_to_cart', as: 'add_to_cart'
  post '/products/retire/:id', to: 'products#retire', as: 'retire'
  resources :products do
    resources :reviews, only: [:create, :new]
  end
  resources :categories

  ############users
  resources :users, only: [:index, :show, :edit]
  get '/users/id/user_account', to: 'users#user_account', as: 'user_account'
  get '/users/id/order_history', to: 'users#order_history', as: 'order_history'
  get '/users/id/manage_tours', to: 'users#manage_tours', as: 'manage_tours'
  get '/users/id/retail_history', to: 'users#retail_history', as: 'retail_history'

  get "/auth/github", as: "github_login"
  get "/auth/:provider/callback", to: "users#create", as: "auth_callback"
  delete "/logout", to: "users#destroy", as: "logout"

  ##########orders
  get '/orders/shopping_cart', to: 'orders#shopping_cart', as: 'shopping_cart'
  get '/orders/id/submit', to: 'orders#submit', as: 'order_submit'
  resources :orders, except: [:new, :index]
  resources :payment_infos, except: [:index, :show]

  #########order_items
  resources :order_items, except: [:index, :show, :new]
  patch '/order_items/:id/add', to: "order_items#increase_qty", as: "add"
  patch '/order_items/:id/subtract', to:"order_items#decrease_qty", as: "subtract"

  #########order_items
  get 'about/index', to: 'about#index', as: 'about'


end
