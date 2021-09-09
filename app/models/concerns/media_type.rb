# frozen_string_literal: true

module MediaType
  extend ActiveSupport::Concern

  included do
    enum type: {
      common: 'common',
      menu: 'menu',
      image_map: 'image_map'
    }, _prefix: :type
  end
end
