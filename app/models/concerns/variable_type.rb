# frozen_string_literal: true

module VariableType
  extend ActiveSupport::Concern

  included do
    enum type: {
      text: 'text',
      image: 'image',
      pdf: 'pdf',
      date: 'date',
      datetime: 'datetime',
      time: 'time'
    }
  end
end
