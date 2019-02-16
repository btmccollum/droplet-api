Rails.application.routes.draw do
  devise_for :users, controllers: { omniauth_callbacks: 'api/v1/users/omniauth_callbacks' }
  
  namespace :api do
    namespace :v1 do
      resources :users, only: %i[index create destroy]
      resources :sessions, only: %i[create destroy]

      get '/check_for_user', to: 'users#check_for_user'
      get '/login', to: 'sessions#create'
    end
  end

  get '/users/sign_in', to: 'api/v1/users/omniauth_callbacks#reddit'
  # devise_scope :user do
  #   get 'sign_in', :to => 'devise/sessions#new', :as => :new_user_session
  #   get 'sign_out', :to => 'devise/sessions#destroy', :as => :destroy_user_session
  # end

  # get '/auth/:provider/callback', to: 'api/v1/users#create'
  # devise_scope :user do 
  #   # get '/auth/reddit/callback', to: 'api/v1/users/omniauth_callbacks#reddit'
  #   get '/login', to: 'api/v1/sessions#create'
  # end
  
  # get "/login", to: "sessions#new"
  # get 'user', to: 'users#show', as: 'user_show'
  #     post 'signup', to: 'users#create', as: 'user_signup'
  #     post 'login', to: 'users#login', as: 'user_login'

end
