# frozen_string_literal: true

# == Schema Information
#
# Table name: broadcasts
#
#  id              :bigint           not null, primary key
#  conditions      :json
#  date_start      :string(255)
#  deleted_at      :datetime
#  deliver_at      :datetime
#  deliver_now     :boolean          default(TRUE)
#  schedule_at     :datetime
#  status          :string(255)
#  title           :string(255)
#  type            :string(255)
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  line_account_id :bigint
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
  has_many :broadcast_messages
  has_many :taggings, as: :taggable
  has_many :tags, through: :taggings

  validates :title, presence: true, length: { maximum: 255 }
  validates :schedule_at, presence: true

  enum status: { draft: 'draft', pending: 'pending', sending: 'sending', done: 'done', failed: 'failed', canceled: 'canceled' }, _prefix: true
end
