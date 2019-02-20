class Api::V1::Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
    skip_before_action :authenticate, only: %i[reddit]
    
    def reddit
        user = User.find_by(state_token: params[:state])     
        user.update_from_omniauth(request.env["omniauth.auth"])

        if user.save
            redirect_to 'http://localhost:3001'
        end   
    end
end