class Api::V1::SessionsController < ApplicationController
    skip_before_action :authenticate, only: %i[create login logout]

    # normal login flow, not OAuth
    def create 
        credentials = user_hash(params[:body])
        user = User.find_by(email: credentials[:email])
    
        if user && user.valid_password?(credentials[:password])
            jwt = Auth.encrypt({id: user.id})

            render json: { current: user, preferences: user.preference_setting, jwt: jwt}
        else
          render json: { error: 'Invalid Credentials.'}, status: 404
        end
    end

    def logout
        cookies.delete(:jwt)
        render json: { user: 'removed' }, status: 200
    end

    def get_posts

    end

    private

    def generate_token
        Sysrandom.random_number(32)
    end
end