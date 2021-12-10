# frozen_string_literal: true

# Get a list of users who added your LINE Official Account as a friend
class LineApi::GetQuota < LineApi::BaseRequest
  def perform
    response = client.get_quota
    quota = JSON.parse(response.body)
    quota['value']
  end
end
