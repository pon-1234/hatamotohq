# frozen_string_literal: true

# == Schema Information
#
# Table name: rich_menus
#
#  id                       :bigint           not null, primary key
#  areas                    :json
#  chat_bar_text            :string(255)
#  deleted_at               :datetime
#  enabled                  :boolean
#  end_at                   :datetime
#  name                     :string(255)
#  selected                 :boolean
#  size                     :json
#  start_at                 :datetime
#  status                   :string(255)      default("pending")
#  created_at               :datetime         not null
#  updated_at               :datetime         not null
#  folder_id                :bigint
#  line_account_id          :bigint
#  line_menu_id(richMenuId) :string(255)
#  media_id                 :bigint
#  template_id              :string(255)
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
  belongs_to :line_account
  belongs_to :folder
  belongs_to :media

  # Validation
  validates :name, presence: true, length: { maximum: 255 }
  validates_presence_of :size, :areas, :selected
  # validate :time_is_not_overlapped

  # Scope
  enum status: { pending: 'pending', done: 'done', error: 'error' }

  after_create_commit :execute_after_create_commit

  def image_url
    media.url
  end

  private
    def time_is_not_overlapped
      RichMenu.where(line_account: self.line_account).each do |r|
        if !((end_at <= r.start_at) || (start_at >= r.end_at))
          next if id.present? && id == c.id
          errors.add(:time, '別の時間範囲を選択してください。 選択した範囲がオーバーラップしました。')
        end
      end
    end

    def execute_after_create_commit
      DispatchRichMenuJob.perform_later(self.id)
    end
end
