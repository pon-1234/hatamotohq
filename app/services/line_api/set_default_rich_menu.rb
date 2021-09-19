# frozen_string_literal: true

# Sets the default rich menu.
# The default rich menu is displayed to all users who have
# added your LINE Official Account as a friend and are
# not linked to any per-user rich menu.
# If a default rich menu has already been set,
# calling this endpoint replaces the current default rich menu
# with the one specified in your request.
class LineApi::SetDefaultRichMenu < LineApi::BaseRequest
  def perform(rich_menu_id)
    client.set_default_rich_menu(rich_menu_id)
  end
end
