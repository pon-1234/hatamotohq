# frozen_string_literal: true

# Cancels the default rich menu set with the Messaging API.
class LineApi::UnsetDefaultRichMenu < LineApi::BaseRequest
  def perform
    response = client.unset_default_rich_menu
    response.code == HTTP_OK
  end
end
