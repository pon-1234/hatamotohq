# frozen_string_literal: true

# Get a list of users who added your LINE Official Account as a friend
class LineApi::ReplyMessage < LineApi::BaseRequest
  def perform(messages, reply_token)
    response = client.reply_message(reply_token, messages)
    response.code == HTTP_OK
  end
end
