# frozen_string_literal: true

module MediaType
  extend ActiveSupport::Concern

  included do
    enum type: {
      image: 'image',
      audio: 'audio',
      video: 'video',
      richmenu: 'richmenu',
      imagemap: 'imagemap',
      pdf: 'pdf'
    }, _prefix: :type
  end
end
