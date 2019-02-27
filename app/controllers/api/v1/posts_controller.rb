class Api::V1::PostsController < ApplicationController
    before_action :is_token_expired?, except: %i[post_test]

    def fetch_posts
        subreddits = eval(request.params['0'])[:subreddits]
        
        # handle get request for user feed
        if subreddits.length > 0 
            query_string = subreddits.join(",").gsub(",", "+")

            # using manual json route (old reddit api setup) instead of API endpoint, no endpoint available at this time for this type of request
            posts = Faraday.new(:url => "https://www.reddit.com/r/#{query_string}.json")
            postlist = posts.get do |req|
                req.params['limit'] = 100
            end
            binding.pry
        else 
            # serving r/best by default if no feed is passed in somehow
            posts = Faraday.new(:url => 'https://oauth.reddit.com/best')
    
            postlist = posts.get do |req|
                req.headers['Authorization'] = "bearer #{current_user.authentication_token}"
                req.headers['User-Agent'] = "Ruby:Droplet API/0.0.0 by u/unovie"
                req.params['limit'] = 100
                req.params['t'] = 'day'
            end
        end
        
        post_hash = JSON.parse(postlist.body)
        render json: { posts: post_hash}
    end

    # def fetch_posts
    #     # binding.pry
    #     # subreddits = eval(params['0'])[:args]
    #     # if subreddits.length > 0 
    #     #     posts = Faraday.new(:url => 'https://oauth.reddit.com/r/all/top')
        # posts = Faraday.new(:url => 'https://oauth.reddit.com/best')
    
        # postlist = posts.get do |req|
        #     req.headers['Authorization'] = "bearer #{current_user.authentication_token}"
        #     req.headers['User-Agent'] = "Ruby:Droplet API/0.0.0 by u/unovie"
        #     req.params['limit'] = 100
        #     req.params['t'] = 'day'
        # end

    #     post_hash = JSON.parse(postlist.body)
    #     render json: { posts: post_hash}
    # end

    def post_test
        render json: { test: 'hello'}
    end

    private

    def is_token_expired?
        current_user.refresh_token_if_expired
    end 
end