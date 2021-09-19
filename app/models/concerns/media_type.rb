# frozen_string_literal: true

module MediaType
  extend ActiveSupport::Concern

  included do
    enum type: {
      image: 'image',
      audio: 'audio',
      video: 'video',
      menu: 'menu',
      image_map: 'image_map'
    }, _prefix: :type
  end
end
