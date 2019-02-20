class Api::V1::PostsController < ApplicationController
    def fetch_posts
        binding.pry
        posts = Faraday.new(:url => 'https://oauth.reddit.com/r/games/top')

        postlist = posts.get do |req|
            req.headers['Authorization'] = "bearer #{auth_params['access_token']}"
            req.headers['User-Agent'] = "Ruby:Droplet API/0.0.0 by u/unovie"
        end

        render json: { posts: postlist}
    end
end