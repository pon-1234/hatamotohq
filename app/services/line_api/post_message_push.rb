# frozen_string_literal: true

# Get a list of users who added your LINE Official Account as a friend
class LineApi::PostMessagePush < LineApi::BaseRequest
  def initialize(channel_id, channel_secret, messages, friend_id)
    @messages = messages
    @friend_id = friend_id
    super(channel_id, channel_secret)
  end

  def perform
    headers = {
      'Authorization' => "Bearer #{@access_token}",
      'Content-Type' => 'application/json'
    }
    options = {
      headers: headers,
      body: {
        to: @friend_id,
        messages: @messages
      }.to_json
    }
    response = self.class.post('/bot/message/push', options)
    response.code == 200
  end
end
