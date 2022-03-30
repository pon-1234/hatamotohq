# frozen_string_literal: true

class Postback::SendReservationInstructionHandler < Postback::BaseHandler
  def perform
    routes = Rails.application.routes.url_helpers
    form_url = routes.reservation_inquiry_form_url(friend_line_id: @friend.line_user_id)
    send_text_message("こちらのリンクにアクセスして、引き続き予約しましょう〜  #{form_url}")
  end
end
