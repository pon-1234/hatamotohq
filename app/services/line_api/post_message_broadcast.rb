# frozen_string_literal: true

# Get a list of users who added your LINE Official Account as a friend
class LineApi::PostMessageBroadcast < LineApi::BaseRequest
  def perform(messages)
    response = client.broadcast(messages)
    response.code == HTTP_OK
  end
end
