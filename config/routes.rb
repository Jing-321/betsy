Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  root to: "products#index"
  resources :products do
    resources :reviews, only: [:create]
  end
  resources :users, only: [:index, :show, :edit]
  get '/users/id/order_history', to: 'users#order_history', as: 'order_history'
  resources :orders, except: [:index, :new]
  resources :order_items, except: [:index, :show, :new]
  resources :reviews, only: [:new]
  #lower priority
  resources :categories


  get "/auth/github", as: "github_login"
  get "/auth/:provider/callback", to: "users#create"
  delete "/logout", to: "users#destroy", as: "logout"

end
