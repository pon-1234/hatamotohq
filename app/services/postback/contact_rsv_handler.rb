# frozen_string_literal: true

require "#{Rails.root}/lib/common/error_handle.rb"

class Postback::ContactRsvHandler < Postback::BaseHandler
  def perform
    guests = Pms::Guest::SearchGuests.new.perform lineId: @friend.line_user_id
    routes = Rails.application.routes.url_helpers
    if guests.present?
      return unless latest_reservation_hash = guests.first.try(:[], 'latest_reservation')
      latest_reservation_hash['guest_phone_number'] = guests.first['phone_number_primary']
      # Only save temporary to DB as a draft record
      last_pms_reservation = LatestPmsReservation.insert_record_from_pms_data latest_reservation_hash, @friend
      confirm_url = "#{routes.confirm_reservation_contacts_url}?friend_line_id=#{@friend.line_user_id}&last_pms_reservation_id=#{last_pms_reservation.id}"
      send_text_message "こちらのリンクにアクセスして、let confirm reservation  #{confirm_url}"
    else
      form_url = routes.contact_new_url friend_line_id: @friend.line_user_id
      send_text_message "こちらのリンクにアクセスして、お問い合わせ情報を入力しましょう〜  #{form_url}"
    end
  rescue => exception
    puts exception.message
  end
end
