class Api::V1::CommentsController < ApplicationController
    before_action :is_token_expired?

    def fetch_comments
        params_hash = eval(params['0'])

        comments = Faraday.new(:url => "https://oauth.reddit.com/r/#{params_hash[:subreddit]}/comments/#{params_hash[:id]}")
    
        commentlist = comments.get do |req|
            req.headers['Authorization'] = "bearer #{current_user.authentication_token}"
            req.headers['User-Agent'] = "Ruby:Droplet API/0.0.0 by u/unovie"
            req.params['show_edits'] = 'true',
            req.params['showmore'] = 'true',
            req.params['sort'] = 'top',
            req.params['context'] = 5,
            req.params['threaded'] = 'true',
            req.params['truncate'] = 'false'
        end
      
        comments_hash = JSON.parse(commentlist.body)
        render json: { comments: comments_hash}
    end
end