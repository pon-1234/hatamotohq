# frozen_string_literal: true

# == Schema Information
#
# Table name: rsv_bookmarks
#
#  id             :bigint           not null, primary key
#  line_friend_id :bigint
#  room_id        :string(255)
#  status         :string(255)
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
end
