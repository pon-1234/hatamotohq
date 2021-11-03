# frozen_string_literal: true

# Get a list of users who added your LINE Official Account as a friend
class LineApi::GetNumberOfMessageDeliveries < LineApi::BaseRequest
  def perform(date)
    formatted_date = date.strftime('%Y%m%d')
    client.get_number_of_message_deliveries(formatted_date)
  end
end
