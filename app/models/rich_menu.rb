# frozen_string_literal: true

# == Schema Information
#
# Table name: rich_menus
#
#  id                              :bigint           not null, primary key
#  areas                           :text(16777215)
#  deleted_at                      :datetime
#  end_at                          :datetime
#  is_active                       :boolean
#  line_chat_bar_text(chatBarText) :string(255)
#  name                            :string(255)
#  selected                        :string(255)
#  size                            :string(255)
#  start_at                        :datetime
#  status                          :string(255)      default("pending")
#  title                           :string(255)
#  created_at                      :datetime         not null
#  updated_at                      :datetime         not null
#  folder_id                       :bigint
#  line_account_id                 :bigint
#  line_menu_id(richMenuId)        :string(255)
#  template_id                     :string(255)
#
# Indexes
#
#  index_rich_menus_on_folder_id        (folder_id)
#  index_rich_menus_on_line_account_id  (line_account_id)
#
# Foreign Keys
#
#  fk_rails_...  (folder_id => folders.id)
#  fk_rails_...  (line_account_id => line_accounts.id)
#
class RichMenu < ApplicationRecord
  belongs_to :line_account
  belongs_to :folder
end
