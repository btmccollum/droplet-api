class Api::V1::PostsController < ApplicationController
    def fetch_posts
        current_user
        posts = Faraday.new(:url => 'https://oauth.reddit.com/r/all/top')
    
        postlist = posts.get do |req|
            req.headers['Authorization'] = "bearer #{current_user.authentication_token}"
            req.headers['User-Agent'] = "Ruby:Droplet API/0.0.0 by u/unovie"
            req.params['limit'] = 10
            req.params['t'] = 'day'
        end

        post_hash = JSON.parse(postlist.body)
        render json: { posts: post_hash}
    end

    def post_test
        render json: { test: 'hello'}
    end
end