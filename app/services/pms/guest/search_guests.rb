# frozen_string_literal: true

require "#{Rails.root}/lib/common/error_handle.rb"

class Pms::Guest::SearchGuests < Pms::BaseRequest
  def perform(guest_info)
    options = {
      headers: auth_header.merge('Content-Type' => 'application/json', 'accept' => 'application/json'),
      body: guest_info.to_json
    }
    response = self.class.post '/guests/search', options
    return nil if response.code != 200
    JSON.parse response.body
  rescue => exception
    raise Common::PmsApiError.new(exception.message)
  end
end
