class ApplicationController < ActionController::API
    include ::ActionController::Cookies
    include ActionController::MimeResponds

    respond_to :json, :html
    # before_action :authenticate_user!
end
