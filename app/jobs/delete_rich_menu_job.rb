# frozen_string_literal: true

class DeleteRichMenuJob < ApplicationJob
  queue_as :default

  def perform(line_account_id, line_menu_id)
    line_account = LineAccount.find(line_account_id)
    LineApi::DeleteRichMenu.new(line_account).perform(line_menu_id)
  end
end
