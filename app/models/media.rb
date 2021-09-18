# frozen_string_literal: true

# == Schema Information
#
# Table name: media
#
#  id              :bigint           not null, primary key
#  alias           :string(255)
#  type            :string(255)
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  line_account_id :bigint
#
# Indexes
#
#  index_media_on_line_account_id  (line_account_id)
#
# Foreign Keys
#
#  fk_rails_...  (line_account_id => line_accounts.id)
#
class Media < ApplicationRecord
  include Rails.application.routes.url_helpers
  include ActiveModel::Validations
  include MediaType

  belongs_to :line_account
  has_one_attached :file
  validates :file, attached: false, content_type: ['image/jpg', 'image/jpeg', 'image/gif', 'image/png', 'application/pdf', 'audio/mpeg', 'video/mp4']
  validates :file, content_type: ['image/jpg', 'image/jpeg', 'image/png'], dimension: { width: 1040, height: 1040 }, if: :type_image_map?
  validates :file, content_type: ['image/jpeg', 'image/png'], if: :type_menu?
  validates_with MediaValidator

  before_create do
    # Set default type to common
    self.type ||= :common
  end

  def url
    url_for(file) if file.attached?
  end

  def preview_url
    url_for(file.representation(resize: '240x240')) if file.attached? && file.representable?
  end
end
