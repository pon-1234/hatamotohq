# frozen_string_literal: true

# Get a list of users who added your LINE Official Account as a friend
class LineApi::PostMessageReply < LineApi::BaseRequest
  def initialize(channel_id, channel_secret, messages, reply_token)
    @messages = messages
    @reply_token = reply_token
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
        replyToken: @reply_token,
        messages: @messages
      }.to_json
    }
    response = self.class.post('/bot/message/reply', options)
    response.code == 200
  end
end
