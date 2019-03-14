class Api::V1::Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
    skip_before_action :authenticate, only: %i[reddit]
    respond_to :json
    
    def reddit
        # need to handle redirect from reddit approval page back to api to front
        user = User.find_by(state_token: params[:state])   
    
        user.update_from_omniauth(env["omniauth.auth"])

        if user.save
            user.linked = true
            user.save
         
            # redirect_to 'http://localhost:3001'
            # adding redirect for herkou deployment
            redirect_to 'https://droplet-app.herokuapp.com/'
        end   
    end

    def failure

    end
end