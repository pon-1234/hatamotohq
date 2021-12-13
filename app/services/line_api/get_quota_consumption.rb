# frozen_string_literal: true

# Get a list of users who added your LINE Official Account as a friend
class LineApi::GetQuotaConsumption < LineApi::BaseRequest
  def perform
    response = client.get_quota_consumption
    quota = JSON.parse(response.body)
    quota['totalUsage']
  end
end
