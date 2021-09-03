# frozen_string_literal: true

module MessageType
  extend ActiveSupport::Concern

  included do
    enum type: {
      system: 'system',
      text: 'text',
      sticker: 'sticker',
      image: 'image',
      video: 'video',
      audio: 'audio',
      location: 'location',
      imagemap: 'imagemap',
      template: 'template',
      flex: 'flex'
    }, _suffix: true
  end
end
