class MediaValidator < ActiveModel::Validator
  IMAGEMAP_MAXSIZE     = 10000000 #10mb
  IMAGE_MAXSIZE  = 10000000 #10mb
  PDF_MAXSIZE    = 10000000 #10mb
  VIDEO_MAXSIZE  = 200000000 #200mb
  AUDIO_MAXSIZE = 10000000 #10mb
  RICHMENU_MAXSIZE = 10000000 #10mb

  def validate(record)
    file = record.file
    if file.image?
    elsif file.video?
    elsif file.audio?
    end
  end
end