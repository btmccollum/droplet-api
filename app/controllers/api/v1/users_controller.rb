class Api::V1::UsersController < ApplicationController
   def index
    @users = User.all
    render json: @users, status: :ok
   end
   
    def create
      binding.pry
      if params[:error]
         puts "LOGIN ERROR", params
         redirect_to "https://localhost:3001/"
   #    else
   #    if user&.valid_password?(params[:password])
   #       render json: user, only: %i[email authentication_token], status: :created
   #   else
   #       head(:unauthorized)
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