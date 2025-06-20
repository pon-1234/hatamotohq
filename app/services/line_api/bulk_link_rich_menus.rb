# frozen_string_literal: true

# Link a rich menu to multiple users at a time
class LineApi::BulkLinkRichMenus < LineApi::BaseRequest
  def perform(user_ids, rich_menu_id)
    response = client.bulk_link_rich_menus(user_ids, rich_menu_id)
    response.code == HTTP_OK or response.code == HTTP_ACCEPTED
  end
end
