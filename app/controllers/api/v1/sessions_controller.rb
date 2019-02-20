class Api::V1::SessionsController < ApplicationController
    # def create
    #     token = generate_token
    #     @redirect_info = {
    #         query_params: {
    #             client_id: ENV['REDDIT_KEY'],
    #             response_type: "code",
    #             redirect_uri: ENV['REDIRECT_URI'],
    #             duration: "permanent",
    #             state: token,
    #             scope: "identity edit read save submit subscribe vote history"
    #         }.to_query,
    #         url: "https://www.reddit.com/api/v1/authorize?"
    #     }
    #     render json: @redirect_info
    # end

    def create 
        user = User.find_by(params[:email])
        user_obj = JSON.parse(params[:body])['user']

        if user && user.valid_password?(user_obj['password'])
          created_jwt = JsonWebToken.encode({id: user.id})

          cookies.signed[:jwt] = {value:  created_jwt, httponly: true}

          render json: {email: user.email}
        else
          render json: {
            error: 'Username or password incorrect'
          }, status: 404
        end
    end

    def destroy

    end

    def logout
        cookies.delete(:jwt)
    end


    # creating action to handle userless authentication, allows the app to function without a user to see default pages 
    def userless_auth
        if params[:error]
            puts "LOGIN ERROR", params
            redirect_to "https://localhost:3001/"
        else
            # upon successful authorization redirect we have to make a post request for access token
            conn = Faraday.new(:url => 'https://www.reddit.com/api/v1/access_token')
            
            # Reddit API requires HTTP basic auth, user and password are App client & secret
            conn.basic_auth(ENV['REDDIT_KEY'], ENV['REDDIT_SECRET'])
    
            # API requirements for body
            body = { grant_type: "client_credentials" }
    
            response = conn.post do |req|
                req.body = body
            end
    
            auth_params = JSON.parse(response.body)

            render json: { currentUser: auth_params }

            # binding.pry 
            # posts = Faraday.new(:url => 'https://oauth.reddit.com/r/games/top')
            # # headers = { "Authorization" : "bearer #{auth_params['access_token']}", 
            # # 'User-Agent': 'Droplet API/0.0.0 by u/unovie'}
    
            # postlist = posts.get do |req|
            #     req.headers['Authorization'] = "bearer #{auth_params['access_token']}"
            #     req.headers['User-Agent'] = "Ruby:Droplet API/0.0.0 by u/unovie"
            # end
            # binding.pry
            # render json: { currentUser: auth_params, posts: postlist}
        end
    end

    def get_posts

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