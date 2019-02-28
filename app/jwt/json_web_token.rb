class JsonWebToken
    JWT_SECRET = ENV["JWT_SECRET"]

    ALGORITHM = 'HS256'

    def self.encode(payload, exp = 72.hours.from_now)
      payload[:exp] = exp.to_i
      JWT.encode(payload, JWT_SECRET, ALGORITHM)
    end

    def self.decode(token)
      # body = JWT.decode(token, JWT_SECRET)[0]
      # HashWithIndifferentAccess.new body
      # rescue JWT::ExpiredSignature, JWT::VerificationError => e
      #   raise ExceptionHandler::ExpiredSignature, e.message
      # rescue JWT::DecodeError, JWT::VerificationError => e
      #   raise ExceptionHandler::DecodeError, e.message
      JWT.decode(token, JWT_SECRET, { algorithm: ALGORITHM }).first
    end
  end