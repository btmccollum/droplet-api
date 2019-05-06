class Api::V1::UsersController < ApplicationController
   skip_before_action :authenticate, only: %i[create]
   before_action :passwords_match?, only: %i[create]
   
   # creating a user with information passed from droplet-web frontend
   def create
      # establish hash from frontend and sanitize data
      credentials = user_hash(params[:body])
      user_email = credentials[:email]
      user_email.chomp.downcase!
      user = User.new(email: user_email)
      user.password = credentials[:password]
      user.save
      user.preference_setting = PreferenceSetting.create
      
      if user.save
         # create JWT token for authorization checks
         jwt = Auth.encrypt({id: user.id})
         
         render json: { current: user, preferences: user.preference_setting.id, jwt: jwt }
      else
         render json: { error: user.errors.full_messages.uniq }, status: 400
      end
  end

  def destroy
      # A response is rendered otherwise a response will not be returned without a defined current_user
      render json: {}, status: 200
      User.destroy(current_user.id)
  end

   # Reddit requires a user to be redirected to their page for approval, creating hash to pass to front end for routing
  def link_oauth
      # Reddit requires state token for droplet's use to further verify user
      state_token = Sysrandom.urlsafe_base64(32)
      current_user.update(state_token: state_token)

      # creating hash to pass to frontend for OAuth redirect
      @redirect_info = {
         query_params: {
            client_id: ENV['REDDIT_KEY'],
            response_type: "code",
            redirect_uri: ENV['REDIRECT_URI'],
            duration: "permanent",
            state: state_token,
            scope: "identity edit read save submit subscribe vote history"
         }.to_query,
         url: "https://www.reddit.com/api/v1/authorize?"
      }
      render json: @redirect_info
   end

   def load_user
      render json: { current: current_user, preferences: current_user.preference_setting }
   end

   def check_for_user
      if user_signed_in?
         @user = current_user
      else
         @user = {}
      end

      render json: @user
   end

   private

   def user_params
      params.require(:user).permit(
          :email,
          :password,
          :password_confirmation,
          :firstname,
          :lastname
      )
   end

   def passwords_match?
      credentials = user_hash(params[:body])
      unless credentials[:password] == credentials[:password_confirmation] 
         error_message = ["Passwords must match."]
 
         render json: { error: error_message }, status: 400
      end
   end
end