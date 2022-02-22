# frozen_string_literal: true

class Postback::RemoveRsvBookmarkHandler < Postback::BaseHandler
  def perform
    reservation_id = @content['reservation_id']
    return if reservation_id.nil?
    if Reservation.find(reservation_id)&.cancel
      send_text_message('空室待ちをキャンセルしました。')
    end
  end
end
