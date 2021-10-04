# frozen_string_literal: true

# == Schema Information
#
# Table name: media
#
#  id              :bigint           not null, primary key
#  line_account_id :bigint
#  type            :string(255)
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
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
  default_scope { order(created_at: :desc) }
  include Rails.application.routes.url_helpers
  include ActiveModel::Validations
  include MediaType

  belongs_to :line_account
  has_one_attached :file
  has_one :rich_menu, dependent: :nullify
  validates :file, attached: false, content_type: ['image/jpg', 'image/jpeg', 'image/gif', 'image/png', 'application/pdf', 'audio/mpeg', 'video/mp4']
  validates :file, content_type: ['image/jpg', 'image/jpeg', 'image/png'], dimension: { width: 1040, height: 1040 }, if: :type_imagemap?
  validates :file, content_type: ['image/jpeg', 'image/png'], if: :type_richmenu?
  validates_with MediaValidator

  before_create do
    next if self.type.present?
    self.type = :image if self.file.image?
    self.type = :audio if self.file.audio?
    self.type = :video if self.file.video?
    self.type = :pdf if self.file.content_type.eql?('application/pdf')
  end

  def url
    rails_public_blob_url(file) if file.attached?
  end

  def preview_url
    if file.attached? && file.representable?
      rails_public_blob_url(file.representation(resize: '240x240').processed)
    end
  rescue StandardError => e
    logger.error('Could not generate preview url')
  end

  def set_blob_duration(duration)
    file.blob.update_columns(duration: duration)
  end
end
