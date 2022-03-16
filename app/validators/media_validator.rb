# frozen_string_literal: true

class MediaValidator < ActiveModel::Validator
  include ActiveSupport::NumberHelper

  IMAGEMAP_MAXSIZE     = 10000000 # 10mb
  IMAGE_MAXSIZE  = 10000000 # 10mb
  PDF_MAXSIZE    = 10000000 # 10mb
  VIDEO_MAXSIZE  = 200000000 # 200mb
  AUDIO_MAXSIZE = 200000000 # 200mb
  RICHMENU_MAXSIZE = 10000000 # 10mb

  def validate(record)
    file = record.file
    file_size = file.byte_size
    if (file.image? && file_size > IMAGE_MAXSIZE) || (file.video? && file_size > VIDEO_MAXSIZE) || (file.audio? && file_size > AUDIO_MAXSIZE) || (record.type_imagemap? && file_size > IMAGEMAP_MAXSIZE)
      record.errors.add :file, I18n.t('errors.messages.file_size_out_of_range', file_size: number_to_human_size(file_size))
    end
  end
end
