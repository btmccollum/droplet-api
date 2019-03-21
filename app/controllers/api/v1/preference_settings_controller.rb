class Api::V1::PreferenceSettingsController < ApplicationController
    before_action :is_token_expired?

    def index
        user_feed = PreferenceSetting.where(user_id == current_user.id).first

        render json: { feed: user_feed }
    end

    def update
        feed = current_user.preference_setting
        subreddit = eval(params['body'])[:subreddit]
        subreddit.downcase!

        if subreddit.present?  && subreddit != 'undefined' && !feed.subreddits.include?(subreddit) 
            feed.subreddits << subreddit
        end
        
        feed.save

        render json: { feed: feed}
    end

    # removing subreddits from preference_setting subreddits array
    def destroy
        feed = current_user.preference_setting
        subreddit = eval(params['body'])[:subreddit]
        subreddit.downcase!

        if feed.subreddits.include?(subreddit) 
            feed.subreddits.delete(subreddit)
        end
        
        feed.save

        render json: { action: "Successfully Deleted"}
    end
end