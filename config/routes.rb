Rails.application.routes.draw do
  # devise_for :users
  namespace :api do
    namespace :v1 do
      resources :users, only: %i[index create destroy]
      resources :sessions, only: %i[create destroy]

      get '/check_for_user', to: 'users#check_for_user'
      get '/login', to: 'sessions#create'
    end
  end

  get '/auth/:provider/callback', to: 'api/v1/users#create'
  
  # get "/login", to: "sessions#new"
  # get 'user', to: 'users#show', as: 'user_show'
  #     post 'signup', to: 'users#create', as: 'user_signup'
  #     post 'login', to: 'users#login', as: 'user_login'

end
