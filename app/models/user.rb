class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :omniauthable, omniauth_providers: %i[reddit]

  def update_from_omniauth(auth)
    self.username = auth.info.name
    self.img = auth.extra.raw_info.icon_img # assuming the self model has an image
    self.provider = auth.provider
    self.uid = auth.uid
    self.authentication_token = auth.credentials.token
    self.refresh_token = auth.credentials.refresh_token
    self.refresh_duration = auth.credentials.expires_at
  end

  # def refresh_token_if_expired
  #   if token_expired?
  #     response    = RestClient.post "#{ENV['DOMAIN']}oauth2/token", :grant_type => 'refresh_token', :refresh_token => self.refresh_token, :client_id => ENV['APP_ID'], :client_secret => ENV['APP_SECRET'] 
  #     refreshhash = JSON.parse(response.body)
  
  #     token_will_change!
  #     expiresat_will_change!
  
  #     self.token     = refreshhash['access_token']
  #     self.expiresat = DateTime.now + refreshhash["expires_in"].to_i.seconds
  
  #     self.save
  #     puts 'Saved'
  #   end
  # end
  
  # def token_expired?
  #   expiry = Time.at(self.expiresat) 
  #   return true if expiry < Time.now # expired token, so we should quickly return
  #   token_expires_at = expiry
  #   save if changed?
  #   false # token not expired. :D
  # end

end
