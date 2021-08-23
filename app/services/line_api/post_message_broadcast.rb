# frozen_string_literal: true

# Get a list of users who added your LINE Official Account as a friend
class LineApi::PostMessageBroadcast < LineApi::BaseRequest
  def initialize(channel_id, channel_secret, messages)
    @messages = messages
    super(channel_id, channel_secret)
  end

  def perform
    headers = { 
      'Authorization' => "Bearer #{@access_token}",
      'Content-Type' => 'application/json'
    }
    options = {
      headers: headers,
      body: { messages: @messages }.to_json
    }
    response = self.class.post("/bot/message/broadcast", options)
    return nil if response.code != 200
    JSON.parse(response.body)
  end
end
