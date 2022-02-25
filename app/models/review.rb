# frozen_string_literal: true

# == Schema Information
#
# Table name: reviews
#
#  id             :bigint           not null, primary key
#  client_id      :bigint
#  line_friend_id :bigint
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#
# Indexes
#
#  index_reviews_on_client_id       (client_id)
#  index_reviews_on_line_friend_id  (line_friend_id)
#
# Foreign Keys
#
#  fk_rails_...  (client_id => clients.id)
#  fk_rails_...  (line_friend_id => line_friends.id)
#
class Review < ApplicationRecord
  has_many :review_answers, dependent: :destroy
  belongs_to :line_friend
  belongs_to :client
  accepts_nested_attributes_for :review_answers

  scope :last_reviews_of_friends, -> do
    group(:line_friend_id, :client_id).select('max(reviews.id) as id, line_friend_id, client_id, max(reviews.created_at) as created_at')
      .order('created_at desc')
  end
end
