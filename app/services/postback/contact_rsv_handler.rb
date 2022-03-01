# frozen_string_literal: true

require "#{Rails.root}/lib/common/error_handle.rb"

class Postback::ContactRsvHandler < Postback::BaseHandler
  def perform
    guests = Pms::Guest::SearchGuests.new.perform lineId: @friend.line_user_id
    if guests.present?
      return unless latest_reservation = guests.first.try(:[], 'latest_reservation')
      LatestPmsReservation.insert_record_from_pms_data latest_reservation, @friend
      ReservationMailer.contact_to_client(@friend, latest_reservation).deliver_now
    else
      routes = Rails.application.routes.url_helpers
      form_url = routes.contact_new_url friend_line_id: @friend.line_user_id
      send_text_message "こちらのリンクにアクセスして、お問い合わせ情報を入力しましょう〜  #{form_url}"
    end
  rescue => exception
    puts exception.message
  end
end
