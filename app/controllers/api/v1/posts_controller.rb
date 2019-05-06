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
                req.params['over_18'] = 'false'
                req.params['sort'] = 'new'
            end
        else 
            # serving r/best by default if no feed is passed in somehow
            posts = Faraday.new(:url => 'https://oauth.reddit.com/best')
    
            postlist = posts.get do |req|
                req.headers['Authorization'] = "bearer #{current_user.reddit_token}"
                req.headers['User-Agent'] = "Ruby:Droplet API/0.0.0 by u/unovie"
                req.params['limit'] = 100
                req.params['over_18'] = 'false'
                req.params['t'] = 'day'
            end
        end
        
        post_hash = JSON.parse(postlist.body)
        render json: { posts: post_hash}
    end

    def post_test
        render json: { test: 'hello'}
    end

    private

    def is_token_expired?
        if current_user.refresh_token
            current_user.refresh_token_if_expired
        else
            false
        end
    end 
end