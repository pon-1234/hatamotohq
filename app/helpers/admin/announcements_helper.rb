# frozen_string_literal: true

module Admin::AnnouncementsHelper
  def find_attachment_by_name_and_model(model, name)
    ActiveStorage::Attachment.includes([:blob]).references([:blob]).where(record_type: model).where('active_storage_blobs.filename LIKE ?', "%#{name}%")
  end

  def create_blob(file, filename, content_type = nil)
    ActiveStorage::Blob.create_and_upload!(
      io: file,
      filename: filename,
      content_type: content_type
    )
  end
end
