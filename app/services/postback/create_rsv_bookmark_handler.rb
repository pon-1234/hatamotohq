# frozen_string_literal: true

class Postback::CreateRsvBookmarkHandler < Postback::BaseHandler
  def perform
    reservation = Reservation.find_or_create_by(
      line_account: @friend.line_account,
      room_id: @content['roomId'],
      room_name: @content['roomName'],
      line_friend: @friend,
      status: :wait
    )
    reservation.update_notifier_id_from_pms(@content['reservation_inquiry_id'])
    # Send message inform user that the room is bookmarked
    send_text_message('キャンセル待ちを開始しました。入力した期間内で在庫があったらお知らせします。') if reservation.present?
  end
end
