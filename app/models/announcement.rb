# frozen_string_literal: true

# == Schema Information
#
# Table name: announcements
#
#  id           :bigint           not null, primary key
#  title        :text
#  body         :text
#  announced_at :datetime
#  status       :string
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#
class Announcement < ApplicationRecord
  default_scope { order(created_at: :desc) }

  has_one_attached :image

  # Validation
  validates_presence_of :title, length: { maximum: 512 }
  validates_presence_of :body, :announced_at

  # Scope
  enum status: { published: 'published', unpublished: 'unpublished', draft: 'draft' }

  scope :for_user, -> { published.where('announced_at <= ?', Time.zone.now) }
end
