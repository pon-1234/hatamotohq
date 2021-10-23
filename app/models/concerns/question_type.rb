# frozen_string_literal: true

module QuestionType
  extend ActiveSupport::Concern

  included do
    enum type: {
      text: 'text',
      textarea: 'textarea',
      radio: 'radio',
      checkbox: 'checkbox',
      pulldown: 'pulldown',
      file: 'file',
      date: 'date'
    }, _prefix: true
  end
end
