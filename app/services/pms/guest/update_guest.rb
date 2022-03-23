# frozen_string_literal: true

require "#{Rails.root}/lib/common/error_handle.rb"

class Pms::Guest::UpdateGuest < Pms::BaseRequest
  def perform(pms_guest_id, line_friend_information = {})
    options = {
      headers: auth_header.merge('Content-Type' => 'application/json', 'accept' => 'application/json'),
      body: line_friend_information.to_json
    }
    response = self.class.patch "/guests/#{pms_guest_id}", options
    raise Common::PmsApiError.new(response.message) if response.code != 200
    JSON.parse response.body
  rescue => exception
    raise Common::PmsApiError.new(exception.message)
  end
end
