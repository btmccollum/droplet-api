Rails.application.routes.draw do
  # devise_for :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
# root '/'
  namespace :api do
    namespace :v1 do
      resources :users, only: %i[index create destroy]
      resources :sessions, only: %i[create destroy]
    end
  end

  get '/auth/:provider/callback', to: 'sessions#create'
  # get "/login", to: "sessions#new"
  # get 'user', to: 'users#show', as: 'user_show'
  #     post 'signup', to: 'users#create', as: 'user_signup'
  #     post 'login', to: 'users#login', as: 'user_login'

end
