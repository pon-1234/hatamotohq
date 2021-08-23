class Media < ApplicationRecord
  include Rails.application.routes.url_helpers
  include ActiveModel::Validations

  belongs_to :line_account
  has_one_attached :file
  validates_with MediaValidator

  def url
    url_for(file) if file.attached?
  end

  def preview_url
    url_for(file.representation(resize: '512x512')) if file.attached? && file.representable?
  end
end
