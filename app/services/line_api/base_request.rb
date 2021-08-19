module LineApi
  class BaseRequest
    attr_reader :access_token

    include HTTParty
    base_uri 'https://api.line.me/v2'

    def initialize(channel_id, channel_secret)
      @channel_id = channel_id
      @channel_secret = channel_secret
      get_access_token
    end

    def get_access_token
      headers = { "Content-Type" => "application/x-www-form-urlencoded" }
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
      @access_token = jsonBody['access_token']
    end
  end
end