# frozen_string_literal: true

require "#{Rails.root}/lib/common/error_handle.rb"

class Pms::Guest::SearchGuests < Pms::BaseRequest
  def perform(friend_information = {})
    options = {
      headers: auth_header.merge('Content-Type' => 'application/json', 'accept' => 'application/json'),
      body: friend_information.to_json
    }
    response = self.class.post '/guests/search', options
    raise Common::PmsApiError.new(response.message) if response.code != 200
    JSON.parse response.body
  rescue => exception
    raise Common::PmsApiError.new(exception.message)
  end
end
