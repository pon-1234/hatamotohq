# frozen_string_literal: true

module MessageStatus
  extend ActiveSupport::Concern

  included do
    enum status: {
      sending: 'sending',
      sent: 'sent',
      error: 'error'
    }
  end
end
