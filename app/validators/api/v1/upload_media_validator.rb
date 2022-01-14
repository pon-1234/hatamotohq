# frozen_string_literal: true

class Api::V1::UploadMediaValidator
  include ActiveModel::Model
  attr_accessor :type, :file

  validates :type, presence: true, inclusion: { in: %w(image audio video richmenu) }
  validates :file, presence: true
  validate :file_attribute_must_be_a_file

  private
    def file_attribute_must_be_a_file
      unless file.is_a?(ActionDispatch::Http::UploadedFile)
        errors.add :file, :content_type_invalid
      end
    end
end
