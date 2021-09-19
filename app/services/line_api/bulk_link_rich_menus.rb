# frozen_string_literal: true

# Links a rich menu to multiple users.
class LineApi::BulkLinkRichMenus < LineApi::BaseRequest
  def perform(user_ids, rich_menu_id)
    client.bulk_link_rich_menus(user_ids, rich_menu_id)
  end
end
