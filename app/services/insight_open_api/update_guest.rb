# frozen_string_literal: true

class InsightOpenApi::UpdateGuest
  include HTTParty

  def perform(params, id)
    headers = {
      'Content-Type' => 'application/json',
      'X-API-KEY' => ENV['X_API_KEY'],
    }
    body = {
      ageGroup: params[:age_group],
      gender: params[:gender]
    }
    options = {
      headers: headers,
      body: body.to_json
    }
    response = HTTParty.put("#{ENV['API_END_POINT']}/guests/#{id}", options)
    return nil if response.code != 200
    JSON.parse(response.body)
  end
end
