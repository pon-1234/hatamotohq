# frozen_string_literal: true

# Get a list of users who added your LINE Official Account as a friend
class LineApi::Broadcast < LineApi::BaseRequest
  def perform(messages)
    response = client.broadcast(messages)
    ActiveJob::Base.logger.info("Request LineApi::Broadcast Code = #{response.code}")
    response.code == HTTP_OK
  end
end
