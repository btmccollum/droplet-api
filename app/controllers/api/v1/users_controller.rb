class Api::V1::UsersController < ApplicationController
   skip_before_action :authenticate, only: %i[index create]

   def index
    @users = User.all
    render json: @users, status: :ok
   end
   
   def create
      credentials = user_hash(params[:body])
      user = User.new(email: credentials[:email])
      user.password = credentials[:password]
      user.save
      user.preference_setting = PreferenceSetting.create
      if user.save
         jwt = Auth.encrypt({id: user.id})
         
         render json: { current: user, preferences: user.preference_setting.id, jwt: jwt }
      else
         render json: { error: 'Failed to Sign Up' }, status: 400
      end
  end

  def link_oauth
      state_token = Sysrandom.urlsafe_base64(32)
      current_user.update(state_token: state_token)

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
end