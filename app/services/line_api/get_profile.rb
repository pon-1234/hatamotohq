# frozen_string_literal: true

# Get a list of users who added your LINE Official Account as a friend
class LineApi::GetProfile < LineApi::BaseRequest
  def perform(user_id)
    response = client.get_profile(user_id)
    return nil if response.code != HTTP_OK
    JSON.parse(response.body)
  end
end
