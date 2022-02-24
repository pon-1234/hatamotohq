# frozen_string_literal: true

class Postback::SendReviewServiceFormHandler < Postback::BaseHandler
  def perform
    routes = Rails.application.routes.url_helpers
    form_url = routes.review_new_url(friend_line_id: @friend.line_user_id)
    send_text_message("こちらのリンクにアクセスして、LINE INSIGHT 満足度アンケートを答えましょう〜  #{form_url}")
  end
end
