class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :omniauthable, omniauth_providers: %i[reddit]

  # completes a user's profile once they link their reddit account
  def update_from_omniauth(auth)
    self.username = auth.info.name
    self.img = auth.extra.raw_info.icon_img
    self.provider = auth.provider
    self.uid = auth.uid
    self.authentication_token = auth.credentials.token
    self.refresh_token = auth.credentials.refresh_token
    self.refresh_duration = auth.credentials.expires_at
  end

  # A user's token expires after one hour from issuance, this will refresh token if expired
  def refresh_token_if_expired
    if token_expired?
      # upon successful authorization redirect we have to make a post request for access token
      conn = Faraday.new(:url => 'https://www.reddit.com/api/v1/access_token')

      conn.basic_auth(ENV['REDDIT_KEY'], ENV['REDDIT_SECRET'])

      # API requirements for body to obtain new access_token
      body = { 
        grant_type: "refresh_token",
        refresh_token: self.refresh_token,
        duration: 'permanent'
      }

      response = conn.post do |req|
          req.body = body
      end
     
      refresh_hash = JSON.parse(response.body)

      self.authentication_token = refresh_hash['access_token']
      self.refresh_duration = (Time.now + refresh_hash['expires_in']).to_i
    
      self.save
    end
  end
  
  # checking whether or not an hour has elapsed since the token issuance
  def token_expired?
    expiry = Time.at(self.refresh_duration) 
    expiry < Time.now ? true : false
  end

end
