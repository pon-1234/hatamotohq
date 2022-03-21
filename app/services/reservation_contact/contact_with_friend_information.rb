# frozen_string_literal: true

class ReservationContact::ContactWithFriendInformation
  def perform(friend_search_information, friend_line_id)
    friend = LineFriend.find_by_line_user_id friend_line_id
    guests = Pms::Guest::SearchGuests.new.perform friend_search_information
    if guests.present?
      will_update_guest = guests.first
      # synchorize line_user_id from crm system to pms system
      Pms::Guest::UpdateGuest.new.perform will_update_guest['id'], { lineId: friend_line_id }
      if latest_reservation_hash = will_update_guest['latest_reservation']
        latest_reservation_hash['guest_phone_number'] = will_update_guest['phone_number_primary']
        # Only save temporary to DB as a draft record
        last_pms_reservation = LatestPmsReservation.insert_record_from_pms_data latest_reservation_hash, friend
        routes = Rails.application.routes.url_helpers
        confirm_url = "#{routes.confirm_reservation_contacts_url}?friend_line_id=#{@friend.line_user_id}&last_pms_reservation_id=#{last_pms_reservation.id}"
        send_text_message "こちらのリンクにアクセスして、新規予約を確認してください #{confirm_url}"
      end
    else
      send_text_message friend, 'お客様は存在しません。別の方法で連絡してください。'
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
