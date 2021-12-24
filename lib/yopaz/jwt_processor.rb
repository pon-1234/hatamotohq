module Yopaz
  class JwtProcessor
    class << self
      HMAC_SECRET = Rails.application.secrets.secret_key_base.to_s

      def encode payload = {staff_id: nil}, exp = 3.months.from_now
        return nil unless payload[:staff_id] && User.staff.exists?(payload[:staff_id])
        payload[:exp] = exp.to_i
        payload[:jti] = uniqueness_jti payload[:staff_id], exp
        JWT.encode payload, HMAC_SECRET, 'HS256'
      end

      def decode token
        decoded = JWT.decode(token, HMAC_SECRET, true, {verify_jti: true, algorithm: 'HS256'}).first
        HashWithIndifferentAccess.new decoded
      rescue JWT::ExpiredSignature, JWT::InvalidJtiError, JWT::VerificationError, JWT::DecodeError => e
        raise Yopaz::AccessTokenInvalid.new
      end

      # generate one unique identifier for the JWT, and use jti claim
      def uniqueness_jti user_id, exp
        result = nil
        loop do
          raw_string = [HMAC_SECRET, Time.now.to_i].join(':').to_s
          result = Digest::MD5.hexdigest raw_string
          break unless AllowlistedJwt.exists?(jti: result)
        end
        # save jti to allowlisted_jwts for revocation access token after
        AllowlistedJwt.create! user_id: user_id, jti: result, exp: Time.at(exp)
        result
      end
    end
  end
end