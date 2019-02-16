class Api::V1::Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
    def reddit
        binding.pry
        user = User.from_omniauth(request.env["omniauth.auth"])
        # guest_guid = request.env["omniauth.params"]["guestGuid"]

        if user.persisted?
        # ActionCable.server.broadcast("guest:#{guest_guid}", { user: UserSerializer.new(user).to_h })
        sign_in(user)
        redirect_to landing_home_index_path
        end   
    end
end