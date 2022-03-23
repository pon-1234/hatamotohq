# frozen_string_literal: true

class Pms::BaseRequest
  HTTP_OK = '200'
  HTTP_ACCEPTED = '202'

  include HTTParty
  base_uri ENV['PMS_API_URL']

  def initialize
  end

  def auth_header
    @auth_header ||= { 'X-API-KEY' => ENV['PMS_API_KEY'] }
  end
end
