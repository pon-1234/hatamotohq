# frozen_string_literal: true

class ReservationContact::ContactWithFriendInformation
  def perform(friend_search_information, friend_line_id)
    friend = LineFriend.find_by_line_user_id friend_line_id
    guests = Pms::Guest::SearchGuests.new.perform friend_search_information
    if guests.present?
      # synchorize line_user_id from crm system to pms system
      will_update_guest = guests.first
      synchorize_result = Pms::Guest::UpdateGuest.new.perform will_update_guest['id'], { lineId: friend_line_id }
      if synchorize_result && (latest_reservation = synchorize_result['latest_reservation'])
        LatestPmsReservation.insert_record_from_pms_data latest_reservation, friend
        ReservationMailer.contact_to_client(friend, latest_reservation).deliver_now
      end
    else
      send_text_message friend, 'お客様は存在しません。別の方法で連絡してください。'
    end
  rescue => exception
    puts exception.message
  end

  private
    def send_text_message(friend, text)
      message = Messages::MessageBuilder.new(friend, friend.channel, { message: { type: 'text', text: text } }.try(:with_indifferent_access)).perform
      LineApi::PushMessage.new(friend.line_account).perform [message.content], friend.line_user_id
    end
end
