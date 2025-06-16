# frozen_string_literal: true

# == Schema Information
#
# Table name: rich_menus
#
#  id                         :bigint           not null, primary key
#  line_account_id            :bigint
#  folder_id                  :bigint
#  line_menu_id(richMenuId)   :string
#  template_id                :string
#  name                       :string
#  size                       :json
#  chat_bar_text(chatBarText) :string
#  selected                   :boolean
#  areas                      :json
#  status                     :string           default("enabled")
#  enabled                    :boolean
#  created_at                 :datetime         not null
#  updated_at                 :datetime         not null
#  deleted_at                 :datetime
#  media_id                   :bigint
#  target                     :string           default("all")
#  conditions                 :json
#  member_count               :integer          default(0)
#  logs                       :text
#
# Indexes
#
#  index_rich_menus_on_folder_id        (folder_id)
#  index_rich_menus_on_line_account_id  (line_account_id)
#  index_rich_menus_on_media_id         (media_id)
#
# Foreign Keys
#
#  fk_rails_...  (folder_id => folders.id)
#  fk_rails_...  (line_account_id => line_accounts.id)
#  fk_rails_...  (media_id => media.id)
#
class RichMenu < ApplicationRecord
  default_scope { order(created_at: :desc) }

  belongs_to :line_account
  belongs_to :folder
  belongs_to :media

  # Validation
  validates :name, presence: true, length: { maximum: 255 }
  validates_presence_of :size, :areas

  # Scope
  enum status: { enabled: 'enabled', disabled: 'disabled', error: 'error' }
  enum target: { all: 'all', condition: 'condition' }, _prefix: true

  before_destroy :exec_after_destroy

  def image_url
    media&.url
  end

  def clone!
    new_richmenu = self.dup
    new_richmenu.status = :disabled
    new_richmenu.name = self.name + '（コピー）'
    new_richmenu.member_count = 0
    new_richmenu.save!
    new_richmenu
  end

  def clear_logs
    self.logs = nil
  end

  private
    def exec_after_destroy
      DeleteRichMenuJob.perform_later(self.line_account_id, self.line_menu_id)
    end
end
