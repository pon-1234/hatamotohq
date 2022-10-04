# frozen_string_literal: true

class ReservationContact::ContactWithFriendInformation
  def perform(guest_info)
    friend = LineFriend.find_by_line_user_id guest_info['lineId']
    return if friend.nil?
    guest = Pms::Guest::SearchGuests.new(friend.line_account.pms_api_key).perform(guest_info)
    if guest.present?
      # synchorize line_user_id from crm system to pms system
      Pms::Guest::UpdateGuest.new.perform guest['id'], { lineId: friend_line_id }
      if latest_reservation_hash = guest['latest_reservation']
        latest_reservation_hash['guest_phone_number'] = guest['phone_number_primary']
        # Only save temporary to DB as a draft record
        last_pms_reservation = PmsReservation.insert_record_from_pms_data latest_reservation_hash, friend
        routes = Rails.application.routes.url_helpers
        confirm_url = "#{routes.confirm_reservation_contacts_url}?friend_line_id=#{friend.line_user_id}&last_pms_reservation_id=#{last_pms_reservation.id}"
        send_text_message friend, "こちらのリンクにアクセスして、新規予約をご確認ください #{confirm_url}"
      end
    else
      send_text_message friend, 'お客様は存在しません。別の方法でご連絡ください。'
    end
  rescue => exception
    puts exception.message
  end

  private
    def send_text_message(friend, text)
      message = Messages::MessageBuilder.new(nil, friend.channel, { message: { type: 'text', text: text } }.try(:with_indifferent_access)).perform
      LineApi::PushMessage.new(friend.line_account).perform [message.content], friend.line_user_id
    end
end
