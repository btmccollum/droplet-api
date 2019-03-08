class Api::V1::SubredditsController < ApplicationController
    before_action :is_token_expired?

    def fetch_subreddits
        subreddits = Faraday.new(:url => 'https://oauth.reddit.com/subreddits/popular')
    
        subreddit_list = subreddits.get do |req|
            req.headers['Authorization'] = "bearer #{current_user.authentication_token}"
            req.headers['User-Agent'] = "Ruby:Droplet API/0.0.0 by u/unovie"
            req.params['limit'] = 100
        end
        subreddits_hash = JSON.parse(subreddit_list.body)
        
        render json: { subreddits: subreddits_hash}
    end
end