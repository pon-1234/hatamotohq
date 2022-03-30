# frozen_string_literal: true

class ApplicationCable::Connection < ActionCable::Connection::Base
  identified_by :current_user

  def connect
    self.current_user = find_verified_user
    logger.add_tags('ActionCable', current_user.email) if current_user
  end

    private
      def find_verified_user
        verified_user = if cookies.signed[:user_id]
          User.find_by id: cookies.signed[:user_id]
        elsif request.headers['Authorization']
          token_payload = Common::JwtProcessor.decode request.headers['Authorization'].split(' ').last rescue nil
          User.staff.find_by(id: token_payload['staff_id']) if token_payload
        end
        return verified_user if verified_user
        reject_unauthorized_connection
      end
end
