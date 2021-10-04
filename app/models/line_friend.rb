# frozen_string_literal: true

# == Schema Information
#
# Table name: line_friends
#
#  id               :bigint           not null, primary key
#  line_account_id  :bigint
#  line_picture_url :string(255)
#  line_user_id     :string(255)
#  line_name        :string(255)
#  display_name     :string(255)
#  status           :string(255)      default("active")
#  locked           :boolean          default(FALSE)
#  visible          :boolean          default(TRUE)
#  note             :text(65535)
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  deleted_at       :datetime
#
# Indexes
#
#  index_line_friends_on_line_account_id  (line_account_id)
#
# Foreign Keys
#
#  fk_rails_...  (line_account_id => line_accounts.id)
#
class LineFriend < ApplicationRecord
  belongs_to :line_account
  has_one :channel
  has_many :taggings, as: :taggable
  has_many :tags, through: :taggings
  has_many :messages, as: :sender

  # Scope
  enum status: { active: 'active', blocked: 'blocked' }
  scope :created_at_gteq, ->(time) { where('created_at >= ?', time) }
  scope :created_at_lteq, ->(time) { where('created_at <= ?', time) }

  after_create_commit :exec_after_create_commit

  def self.find_all_by_tags(line_account_id, tag_ids)
    LineAccount.find(line_account_id).line_friends.joins(:tags).references(:tags).where(tags: { id: tag_ids })
  end

  def push_event_data
    {
      id: id,
      name: display_name,
      avatar_url: line_picture_url,
      type: 'friend'
    }
  end

  def name
    display_name
  end

  def avatar_url
    line_picture_url
  end

  def toggle_locked
    self.locked = !self.locked
    self.save!
  end

  def toggle_visible
    self.visible = !self.visible
    self.save!
  end

  # Available scenarios that can be sent by configs (on chat, postback action...)
  def manual_scenarios
    all = Scenario.manual.enabled.where(line_account_id: self.line_account_id)
    without_tag = all.select { |_| _.tags.blank? }
    with_tag = all.joins(:tags).references(:tags).where(tags: { id: self.tag_ids })
    without_tag + with_tag
  end

  # Available scenarios that will be sent after making friend
  def auto_scenarios
    all = Scenario.auto.enabled.where(line_account_id: self.line_account_id)
    without_tag = all.select { |_| _.tags.blank? }
    with_tag = all.joins(:tags).references(:tags).where(tags: { id: self.tag_ids })
    without_tag + with_tag
  end

  private
    def exec_after_create_commit
      AcquireFriendJob.perform_later(self.id)
    end
end
