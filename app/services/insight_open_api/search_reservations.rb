# frozen_string_literal: true

class InsightOpenApi::SearchReservations
  include HTTParty

  def perform(check_in_date, phone_number)
    headers = {
      'Content-Type' => 'application/json',
      'X-API-KEY' => ENV['X_API_KEY'],
    }
    body = {
      checkInFrom: check_in_date,
      checkInTo: check_in_date,
      guestPhoneNumber: phone_number
    }
    options = {
      headers: headers,
      body: body.to_json
    }
    response = HTTParty.post("#{ENV['API_END_POINT']}/reservations/search", options)
    return nil if response.code != 200
    JSON.parse(response.body)
  end
end
