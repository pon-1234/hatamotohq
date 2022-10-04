# frozen_string_literal: true

require "#{Rails.root}/lib/common/error_handle.rb"

class Postback::ContactRsvHandler < Postback::BaseHandler
  def perform
    guest = Pms::Guest::SearchGuests.new(@friend.line_account.pms_api_key).perform lineId: @friend.line_user_id
    routes = Rails.application.routes.url_helpers
    if guest.present?
      return unless latest_reservation_hash = guest.try(:[], 'reservationHistory')
      latest_reservation_hash['guest_phone_number'] = guest['phoneNumber']
      # Only save temporary to DB as a draft record
      last_pms_reservation = PmsReservation.insert_record_from_pms_data latest_reservation_hash, @friend
      confirm_url = "#{routes.confirm_reservation_contacts_url}?friend_line_id=#{@friend.line_user_id}&last_pms_reservation_id=#{last_pms_reservation.id}"
      send_text_message "こちらのリンクにアクセスしてから、新規予約をご確認ください #{confirm_url}"
    else
      form_url = routes.contact_new_url friend_line_id: @friend.line_user_id
      send_text_message "こちらのリンクにアクセスしてから、お問い合わせ情報をご入力ください  #{form_url}"
    end
  rescue => exception
    puts exception.message
  end
end
