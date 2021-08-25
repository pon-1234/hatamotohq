# frozen_string_literal: true

# == Schema Information
#
# Table name: line_friends
#
#  id               :bigint           not null, primary key
#  deleted_at       :datetime
#  display_name     :string(255)
#  line_name        :string(255)
#  line_picture_url :string(255)
#  note             :text(65535)
#  status           :string(255)      default("active")
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  line_account_id  :bigint
#  line_user_id     :string(255)
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
  has_many :line_friends, dependent: :destroy

  enum status: { active: 'active', block: 'block', inactive: 'inactive', mute: 'mute' }, _prefix: true
  scope :created_at_gteq, ->(time) { where('created_at >= ?', time) }
  scope :created_at_lteq, ->(time) { where('created_at <= ?', time) }
end
