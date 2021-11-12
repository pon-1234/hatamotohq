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
      image: 'image',
      pdf: 'pdf',
      date: 'date',
      time: 'time',
      datetime: 'datetime'
    }
  end
end
