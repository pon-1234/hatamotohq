# frozen_string_literal: true

# Get a list of users who added your LINE Official Account as a friend
class LineApi::PushMessage < LineApi::BaseRequest
  def perform(messages, friend_id)
    response = client.push_message(friend_id, messages)
    byebug
    response.code == HTTP_OK
  end
end
