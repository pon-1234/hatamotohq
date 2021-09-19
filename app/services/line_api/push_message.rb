# frozen_string_literal: true

# Get a list of users who added your LINE Official Account as a friend
class LineApi::PushMessage < LineApi::BaseRequest
  def perform(messages, friend_id)
    response = client.push_message(friend_id, messages)
    response.code == 200
  end
end
