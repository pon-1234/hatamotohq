# frozen_string_literal: true

module Admin::ActiveStorageHelper
  def create_blob_from_file(file)
    ActiveStorage::Blob.create_and_upload!(
      io: file,
      filename: file.original_filename,
      content_type: file.content_type
    )
  end
end
