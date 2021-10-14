# frozen_string_literal: true

# == Schema Information
#
# Table name: broadcasts
#
#  id              :bigint           not null, primary key
#  line_account_id :bigint
#  conditions      :json
#  title           :string(255)
#  deliver_now     :boolean          default(TRUE)
#  status          :string(255)
#  type            :string(255)
#  schedule_at     :datetime
#  deliver_at      :datetime
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  deleted_at      :datetime
#
# Indexes
#
#  index_broadcasts_on_line_account_id  (line_account_id)
#
# Foreign Keys
#
#  fk_rails_...  (line_account_id => line_accounts.id)
#
class Broadcast < ApplicationRecord
  CONDITION_SEND_ALL = {
    type: 'all',
    add_friend_date: {
      start_date: nil,
      end_date: nil
    },
    age: {
      min: nil,
      max: nil
    },
    gender: nil
  }.freeze

  belongs_to :line_account
  has_many :broadcast_messages, dependent: :destroy
  has_many :taggings, as: :taggable, dependent: :destroy
  has_many :tags, through: :taggings

  validates :title, presence: { unless: :draft? }, length: { maximum: 255 }
  validates :schedule_at, presence: { unless: :draft? }

  enum status: { draft: 'draft', pending: 'pending', sending: 'sending', done: 'done', error: 'error', canceled: 'canceled' }
  enum type: { all: 'all', condition: 'condition' }, _prefix: :broadcast_type # type_condition is already defined by Active Record

  # Get all broadcast to dispatch. The broadcast have status pending and schedule_at < now
  scope :dispatchable, -> { where(status: :pending).where('schedule_at <= ?', Time.zone.now) }

  def editable?
    self.draft? || self.pending?
  end

  def destroyable?
    !self.sending?
  end

  def clone!
    new_broadcast = self.dup
    new_broadcast.title = self.title + '（コピー）'
    new_broadcast.status = :draft
    new_broadcast.tag_ids = self.tag_ids
    new_broadcast.save!
    self.broadcast_messages&.each { |message| message.clone_to!(new_broadcast.id) }
    new_broadcast
  end
end
