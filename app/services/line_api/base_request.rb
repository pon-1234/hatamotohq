# frozen_string_literal: true

require 'line/bot'
class LineApi::BaseRequest
  attr_reader :channel_token

  HTTP_OK = '200'
  HTTP_ACCEPTED = '202'

  include HTTParty
  base_uri 'https://api.line.me/v2'

  def initialize(config)
    if config.is_a?(Hash)
      @channel_id = config[:channel_id]
      @channel_secret = config[:channel_secret]
    else
      @channel_id = config.channel_id
      @channel_secret = config.channel_secret
    end
    get_channel_token
  end

  def client
    @client ||= Line::Bot::Client.new { |config|
      config.channel_id = @channel_id
      config.channel_secret = @channel_secret,
      config.channel_token = @channel_token
    }
  end

  def get_channel_token
    headers = { 'Content-Type' => 'application/x-www-form-urlencoded' }
    body = {
      grant_type: 'client_credentials',
      client_id: @channel_id,
      client_secret: @channel_secret
    }
    options = {
      headers: headers,
      body: body
    }
    response = self.class.post('/oauth/accessToken', options)
    return nil if response.code != 200
    jsonBody = JSON.parse(response.body)
    @channel_token = jsonBody['access_token']
  end
end
