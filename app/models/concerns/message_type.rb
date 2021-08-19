# frozen_string_literal: true

module MessageType
  extend ActiveSupport::Concern

  included do
    enum message_type: {
      incoming: 'incoming',
      outgoing: 'outgoing',
      activity: 'activity',
      bot: 'bot',
      system: 'system'
    }, _suffix: true
  end
end
