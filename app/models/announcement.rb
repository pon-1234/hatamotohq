# frozen_string_literal: true

# == Schema Information
#
# Table name: announcements
#
#  id           :bigint           not null, primary key
#  title        :text(65535)
#  body         :text(4294967295)
#  announced_at :datetime
#  status       :string(255)
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#
class Announcement < ApplicationRecord
  has_one_attached :image

  # Validation
  validates_presence_of :title, length: { maximum: 512 }
  validates_presence_of :body, :announced_at

  # Scope
  enum status: { published: 'published', unpublished: 'unpublished', draft: 'draft' }
  scope :announcement_published, -> { where('status = ? AND announced_at <= ?', 'published', Time.zone.now) }
end
