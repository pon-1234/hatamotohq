# frozen_string_literal: true

# == Schema Information
#
# Table name: media
#
#  id              :bigint           not null, primary key
#  line_account_id :bigint
#  type            :string(255)
#  provider        :string(255)      default("system")
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

  # Validations
  validates :file, content_type: ['image/jpg', 'image/jpeg', 'image/png'], if: :type_image?
  validates :file, content_type: ['audio/m4a', 'audio/x-m4a', 'audio/mp4', 'video/mp4', 'video/quicktime', 'audio/mpeg', 'audio/ogg',
                                  'audio/vnd.wave', 'audio/wave', 'audio/wav', 'audio/x-wav', 'audio/x-ms-wma', 'video/x-ms-asf', 'video/x-ms-wma'], if: :type_audio?
  validates :file, content_type: ['video/mp4', 'video/quicktime'], if: :type_video?
  validates :file, content_type: ['image/jpg', 'image/jpeg', 'image/png'], dimension: { width: 1040 }, if: :type_imagemap?
  validates :file, content_type: ['image/jpeg', 'image/png'], if: :type_richmenu?
  validates_with MediaValidator

  # Scopes
  enum provider: { system: 'system', line: 'line' }, _prefix: true

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
      url_for(file.preview(resize: '240x240').processed)
    end
  rescue
    url
  end

  def download_url
    url_for(file) if file.attached?
  end

  def variant_url(width)
    url_for(file.variant(resize_to_fit: [width, width]))
  end

  def file_name
    self.file.blob.filename
  end

  def set_blob_duration(duration)
    file.blob.update_columns(duration: duration)
  end
end
