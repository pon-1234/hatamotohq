# frozen_string_literal: true

module User::RichMenusHelper
  def build_rich_menu(params)
    rich_menu = RichMenu.new(params)
    rich_menu.status = :enabled
    rich_menu.line_account = Current.user.line_account
    rich_menu
  end
end
