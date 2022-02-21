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
  accepts_nested_attributes_for :review_answers, reject_if: ->(attributes) { attributes['answer'].blank? }, allow_destroy: true
end
