# frozen_string_literal: true

class UserMailer < ApplicationMailer
  default from: ENV.fetch('MAILER_SENDER', 'noreply@yopaz.vn')

  def postback_email(friend_id, payload)
    @friend = LineFriend.find(friend_id)
    receivers = payload['emails']
    @body = payload['text']
    bind_variables
    mail(to: receivers, subject: 'HOTEL INSIGHT CRMシステム')
  end

  private
    def bind_variables
      @body = @body.gsub(/{name}/, @friend.name)
    end
end
