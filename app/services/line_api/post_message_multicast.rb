# frozen_string_literal: true

# Get a list of users who added your LINE Official Account as a friend
class LineApi::PostMessageMulticast < LineApi::BaseRequest
  def perform(messages, friend_ids)
    response = client.multicast(friend_ids, messages)
    response.code == HTTP_OK
  end
end
