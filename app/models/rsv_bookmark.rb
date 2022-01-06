# frozen_string_literal: true

# == Schema Information
#
# Table name: rsv_bookmarks
#
#  id             :bigint           not null, primary key
#  line_friend_id :bigint
#  room_id        :string(255)
#  callback_url   :string(255)
#  status         :string(255)      default("wait")
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#
# Indexes
#
#  index_rsv_bookmarks_on_line_friend_id  (line_friend_id)
#
# Foreign Keys
#
#  fk_rails_...  (line_friend_id => line_friends.id)
#
class RsvBookmark < ApplicationRecord
  belongs_to :line_friend

  # Scopes
  enum status: { wait: 'wait', cancelled: 'cancelled', done: 'done' }

  before_create do
    self.callback_url = generate_callback_url if self.callback_url.nil?
  end

  def cancel
    self.status = :cancelled
    self.save
  end

  def mark_as_done
    self.status = :done
    self.save
  end

  private
    def generate_callback_url
      loop do
        uid = SecureRandom.alphanumeric(32)
        break uid unless RsvBookmark.where(callback_url: uid).first
      end
    end
end
