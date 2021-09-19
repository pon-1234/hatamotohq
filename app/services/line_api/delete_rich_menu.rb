# frozen_string_literal: true

# If you have reached the maximum of 1,000 rich menus with the Messaging API for your LINE Official Account,
# you must delete a rich menu before you can create a new one.
class LineApi::DeleteRichMenu < LineApi::BaseRequest
  def perform(rich_menu_id)
    client.delete_rich_menu(rich_menu_id)
  end
end
