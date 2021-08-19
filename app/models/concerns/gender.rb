# frozen_string_literal: true

module Gender
  extend ActiveSupport::Concern

  included do
    enum gender: {
      male: 'male',
      female: 'female',
      unknown: 'unknown'
    }, _suffix: true
  end
end
