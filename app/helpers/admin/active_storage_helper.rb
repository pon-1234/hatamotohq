# frozen_string_literal: true

module Admin::ActiveStorageHelper
  def create_blob(file, filename, content_type = nil)
    ActiveStorage::Blob.create_and_upload!(
      io: file,
      filename: filename,
      content_type: content_type
    )
  end
end
