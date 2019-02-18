class Api::V1::Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
    def reddit        
        user = User.from_omniauth(request.env["omniauth.auth"])

        if user.persisted?
            sign_in(user)
            redirect_to 'http://localhost:3001'
        end   
    end
end