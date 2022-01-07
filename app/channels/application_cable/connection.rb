# frozen_string_literal: true

class ApplicationCable::Connection < ActionCable::Connection::Base
  identified_by :current_user

  def connect
    if verified_user = User.find_by(id: cookies.signed[:user_id])
      self.current_user = verified_user
      logger.add_tags 'ActionCable', current_user.email
    end
  end

    private
      def find_verified_user(authentication_token)
        verified_user = User.find_by authentication_token: uid
        reject_unauthorized_connection if verified_user.nil?
        verified_user
      end
end
