Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  root to: "products#index"
  resources :products
  resources :users, only: [:index, :show, :edit]
  get '/users/id/user_account', to: 'users#user_account', as: 'user_account'
  get '/users/id/order_history', to: 'users#order_history', as: 'order_history'

  get '/orders/shopping_cart', to: 'orders#shopping_cart', as: 'shopping_cart'
  resources :orders, except: [:new]
  resources :order_items, except: [:index, :show, :new]

  resources :payment_infos, except: [:index, :show]

  #lower priority
  resources :categories

  get "/auth/github", as: "github_login"
  get "/auth/:provider/callback", to: "users#create"
  delete "/logout", to: "users#destroy", as: "logout"

end
