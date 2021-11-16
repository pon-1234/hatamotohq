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
  has_many :survey_responses
  has_many :friend_variables

  # Validations
  validates :display_name, allow_nil: true, length: { maximum: 255 }
  validates :line_name, allow_nil: true, length: { maximum: 255 }
  validates :note, allow_nil: true, length: { maximum: 2000 }

  # Scope
  enum status: { active: 'active', blocked: 'blocked' }
  scope :created_at_gteq, ->(date_str) { where('line_friends.created_at >= ?', date_str&.to_date&.beginning_of_day) }
  scope :created_at_lteq, ->(date_str) { where('line_friends.created_at <= ?', date_str&.to_date&.end_of_day) }

  after_create_commit :exec_after_create_commit

  def self.find_all_by_tags(line_account_id, tag_ids)
    LineAccount.find(line_account_id).line_friends.joins(:tags).references(:tags).where(tags: { id: tag_ids })
  end

  def push_event_data
    {
      id: id,
      name: display_name,
      avatar_url: line_picture_url,
      type: 'friend',
      note: note,
      locked: locked
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
    self.channel.locked = self.locked
    self.channel.save!
  end

  def toggle_visible
    self.visible = !self.visible
    self.save!
  end

  # Available scenarios that can be sent by configs (on chat, postback action...)
  def manual_scenarios
    all = Scenario.manual.includes([:tags, :taggings]).enabled.not_empty.where(line_account_id: self.line_account_id)
    without_tag = all.select { |_| _.tags.blank? }
    with_tag = all.joins(:tags).references(:tags).where(tags: { id: self.tag_ids })
    without_tag + with_tag
  end

  # Available scenarios that will be sent after making friend
  def auto_scenarios
    all = Scenario.auto.includes([:tags, :taggings]).enabled.not_empty.where(line_account_id: self.line_account_id)
    without_tag = all.select { |_| _.tags.blank? }
    with_tag = all.joins(:tags).references(:tags).where(tags: { id: self.tag_ids })
    without_tag + with_tag
  end

  def set_reminder!(reminder_id, goal)
    reminding = Reminding.new(channel: self.channel, reminder_id: reminder_id, goal: goal)
    reminding.save!
  end

  def variables
    FriendVariable.find_by_sql(['
      WITH rfv AS (
      SELECT
        fv.*, ROW_NUMBER() OVER (PARTITION BY variable_id, line_friend_id
      ORDER BY
        id DESC) AS rn
      FROM
        friend_variables AS fv )
      SELECT
        variables.name AS name,
        rfv.value AS value,
        variables.type AS type
      FROM
        variables
      LEFT JOIN rfv ON
        variables .id = rfv.variable_id
        AND rn = 1
        AND rfv.line_friend_id = ?
      WHERE variables.line_account_id = ?
    ', self.id, self.line_account_id]).map { |_| _.attributes }
  end

  private
    def exec_after_create_commit
      AcquireFriendJob.perform_later(self.id)
    end
end
