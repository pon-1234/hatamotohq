# frozen_string_literal: true

class Postback::SendMailHandler < Postback::BaseHandler
  def perform
    SystemMailer.postback_email(@friend.id, @content).deliver_later
  end
end
