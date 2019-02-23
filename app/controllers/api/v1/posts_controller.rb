class Api::V1::PostsController < ApplicationController
    before_action :is_token_expired?, except: %i[post_test]

    def fetch_posts
        posts = Faraday.new(:url => 'https://oauth.reddit.com/r/all/top')
    
        postlist = posts.get do |req|
            req.headers['Authorization'] = "bearer #{current_user.authentication_token}"
            req.headers['User-Agent'] = "Ruby:Droplet API/0.0.0 by u/unovie"
            req.params['limit'] = 25
            req.params['t'] = 'day'
        end

        post_hash = JSON.parse(postlist.body)
        render json: { posts: post_hash}
    end

    def post_test
        render json: { test: 'hello'}
    end

    private

    def is_token_expired?
        current_user.refresh_token_if_expired
    end 
end