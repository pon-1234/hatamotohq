# frozen_string_literal: true

module MessageType
  extend ActiveSupport::Concern

  included do
    enum message_type: {
      text: 'text',
      sticker: 'sticker',
      image: 'image',
      video: 'video',
      audio: 'audio',
      location: 'location',
      imagemap: 'imagemap',
      template_button: 'template_button',
      template_confirm: 'template_confirm',
      template_carousel: 'template_carousel',
      template_image_carousel: 'template_image_carousel',
      flex: 'flex'
    }, _suffix: true
  end
end
