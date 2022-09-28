# frozen_string_literal: true

class Pms::BaseRequest
  HTTP_OK = '200'
  HTTP_ACCEPTED = '202'

  include HTTParty
  base_uri ENV['PMS_API_URL']

  def initialize(api_key)
    @api_key = api_key
  end

  def auth_header
    @auth_header ||= { 'X-API-KEY' => @api_key }
  end
end
