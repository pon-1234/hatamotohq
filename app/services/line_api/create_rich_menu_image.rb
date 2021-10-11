# frozen_string_literal: true

# Get a list of users who added your LINE Official Account as a friend
class LineApi::CreateRichMenuImage < LineApi::BaseRequest
  def perform(richmenu_id, image)
    response = client.create_rich_menu_image(richmenu_id, image)
    response.code == HTTP_OK
  end
end
