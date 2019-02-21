Rails.application.routes.draw do
  devise_for :users, controllers: { omniauth_callbacks: 'api/v1/users/omniauth_callbacks' }
  
  namespace :api do
    namespace :v1 do
      resources :users, only: %i[index create destroy]
      resources :sessions, only: %i[create destroy]
      resources :posts, only: %i[fetch_posts post_test]

      get '/check_for_user', to: 'users#check_for_user'
      # get '/login', to: 'sessions#create'
      get '/userless_auth', to: 'sessions#userless_auth'
      get '/fetch_posts', to: 'posts#fetch_posts'
      post '/auth', to: 'sessions#create'
      post '/logout', to: 'sessions#logout'
      get '/post_test', to: 'posts#post_test'
      get '/link_oauth', to: 'users#link_oauth'
    end
  end

  get '/users/sign_in', to: 'api/v1/users/omniauth_callbacks#reddit'
end
