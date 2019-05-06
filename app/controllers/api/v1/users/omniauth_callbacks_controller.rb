class Api::V1::Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
    skip_before_action :authenticate, only: %i[reddit]
    
    def reddit
        user = User.find_by(state_token: params[:state])   
    
        user.update_from_omniauth(request.env["omniauth.auth"])

        if user.save
            user.linked = true
            user.save
         
            redirect_to 'http://localhost:3001'
            # adding redirect for herkou deployment
            # redirect_to 'https://droplet-app.herokuapp.com/'
        end   
    end

    def failure
        # binding.pry
    end
end