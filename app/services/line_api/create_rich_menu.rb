# frozen_string_literal: true

# Get a list of users who added your LINE Official Account as a friend
class LineApi::CreateRichMenu < LineApi::BaseRequest
  def perform(payload)
    client.create_rich_menu(payload)
  end
end
