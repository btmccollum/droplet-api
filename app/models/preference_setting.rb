class PreferenceSetting < ApplicationRecord
    belongs_to :user

    serialize :subreddits, Array
end
