class Api::V1::UsersController < ApplicationController
   def index
    @users = User.all
    render json: @users, status: :ok
   end
   
    def create
      if params[:error]
         puts "LOGIN ERROR", params
         redirect_to "https://localhost:3001/"
      else
         # upon successful authorization redirect we have to make a post request for access token
         conn = Faraday.new(:url => 'https://www.reddit.com/api/v1/access_token')
         
         # Reddit API requires HTTP basic auth, user and password are App client & secret
         conn.basic_auth(ENV['REDDIT_KEY'], ENV['REDDIT_SECRET'])

         # API requirements for body
         body = {
             grant_type: "authorization_code",
             code: params[:code],
             redirect_uri: ENV['REDIRECT_URI'],
         }

         response = conn.post do |req|
             req.body = body
         end

         auth_params = JSON.parse(response.body)

         binding.pry
     end
    
   end

   def show
   end

   def check_for_user
      if user_signed_in?
         @user = current_user
      else
         @user = {}
      end

      # respond_to do |f|
      #       f.json {render json @user}
      # end
      render json: @user
   end

   private

end