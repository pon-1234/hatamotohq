# frozen_string_literal: true

# Link a rich menu to multiple users at a time
class LineApi::BulkUnlinkRichMenus < LineApi::BaseRequest
  def perform(user_ids)
    response = client.bulk_unlink_rich_menus(user_ids)
    response.code == HTTP_OK or response.code == HTTP_ACCEPTED
  end
end
