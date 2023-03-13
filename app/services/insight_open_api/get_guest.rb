# frozen_string_literal: true

class InsightOpenApi::GetGuest
  include HTTParty

  def perform(id)
    headers = {
      'Content-Type' => 'application/json',
      'X-API-KEY' => ENV['X_API_KEY'],
    }
    response = HTTParty.get("#{ENV['API_END_POINT']}/guests/#{id}", headers: headers)
    return nil if response.code != 200
    JSON.parse(response.body)
  end
end
