# frozen_string_literal: true

require "#{Rails.root}/lib/common/error_handle.rb"

class Pms::Reservation::SearchReservations < Pms::BaseRequest
  def perform(reservation_info)
    options = {
      headers: auth_header.merge('Content-Type' => 'application/json', 'accept' => 'application/json'),
      body: reservation_info.to_json
    }
    response = self.class.post '/reservations/search', options
    return nil if response.code != 200
    JSON.parse response.body
  rescue => exception
    raise Common::PmsApiError.new(exception.message)
  end
end
