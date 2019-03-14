Rails.application.routes.draw do
  devise_for :users, controllers: { omniauth_callbacks: 'api/v1/users/omniauth_callbacks' }
  
  namespace :api do
    namespace :v1 do
      resources :users, only: %i[index create destroy]
      resources :sessions, only: %i[create destroy]
      resources :posts, only: %i[fetch_posts post_test]
      resources :comments, only: %i[fetch_comments]
      resources :preference_settings, only: %i[index create show update destroy]

      get '/auth/reddit/callback', to: 'users/omniauth_callbacks#reddit'
      get '/check_for_user', to: 'users#check_for_user'
      get '/userless_auth', to: 'sessions#userless_auth'
      get '/fetch_posts', to: 'posts#fetch_posts'
      get '/fetch_comments', to: 'comments#fetch_comments'
      post '/auth', to: 'sessions#create'
      post '/logout', to: 'sessions#logout'
      get '/post_test', to: 'posts#post_test'
      get '/link_oauth', to: 'users#link_oauth'
      get '/fetch_subreddits', to: 'subreddits#fetch_subreddits'
      get '/load_user', to: 'users#load_user'
    end
  end

  get '/users/sign_in', to: 'api/v1/users/omniauth_callbacks#reddit'
  get '/auth/failure', to: 'api/v1/users/omniauth_callbacks#failure'
end
