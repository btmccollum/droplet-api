require 'jwt'

# Used to create JWT tokens for authorization between back and frontend in all controller actions
class Auth
    # JWT secret key for encrypting/decoding 
    JWT_SECRET = ENV["JWT_SECRET"]

    # defining encryption HMAC algo, see https://github.com/jwt/ruby-jwt 
    ALGORITHM = 'HS256'

    def self.encrypt(payload)
      JWT.encode(payload, JWT_SECRET, ALGORITHM)
    end
  
    def self.decode(token)
      JWT.decode(token, JWT_SECRET, true, { algorithm: ALGORITHM }).first
    end
  end