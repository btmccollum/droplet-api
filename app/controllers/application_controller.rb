class ApplicationController < ActionController::API
    include ::ActionController::Cookies
    include ActionController::MimeResponds

    respond_to :json, :html
    before_action :authenticate

    def current_user
        if auth_present?
            user = User.find(auth["id"])
            if user
                @current_user ||= user
            end
        end
    end

    def authenticate
        render json: {error: "unauthorized"}, status: 401 unless current_user
    end

    private

        def token
            request.env["HTTP_AUTHORIZATION"].scan(/Bearer (.*)$/).flatten.last
        end

        def auth
            JsonWebToken.decode(token)
        end

        def auth_present?
            if request.env["HTTP_AUTHORIZATION"]
                !!request.env["HTTP_AUTHORIZATION"].scan(/Bearer (.*)$/).flatten.last
            end
        end

        def user_hash(json)
            eval(json)[:user]
        end      

        def is_token_expired?
            current_user.refresh_token_if_expired
        end 
end
