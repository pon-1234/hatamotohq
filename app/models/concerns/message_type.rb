# frozen_string_literal: true

module MessageType
  extend ActiveSupport::Concern

  included do
    enum type: {
      log: 'log',
      text: 'text',
      sticker: 'sticker',
      image: 'image',
      video: 'video',
      audio: 'audio',
      location: 'location',
      imagemap: 'imagemap',
      template: 'template',
      flex: 'flex'
    }, _prefix: true
  end
end
