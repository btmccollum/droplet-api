class Api::V1::SessionsController < ApplicationController
    def create
        token = generate_token
        @redirect_info = {
            query_params: {
                client_id: ENV['REDDIT_KEY'],
                response_type: "code",
                redirect_uri: ENV['REDIRECT_URI'],
                duration: "permanent",
                state: token,
                scope: "identity edit read save submit subscribe vote history"
            }.to_query,
            url: "https://www.reddit.com/api/v1/authorize?"
        }
        render json: @redirect_info
    end

    def destroy

    end

    private

    def respond_with(resource, _opts = {})
        render json: resource
    end

    def respond_to_on_destroy
        head :no_content
    end

    def generate_token
        Sysrandom.random_number(32)
    end
end