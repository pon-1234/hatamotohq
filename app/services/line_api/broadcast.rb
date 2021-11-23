# frozen_string_literal: true

# Get a list of users who added your LINE Official Account as a friend
class LineApi::Broadcast < LineApi::BaseRequest
  def perform(messages)
    client.broadcast(messages)
  end
end
