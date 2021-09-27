# frozen_string_literal: true

class Ws::ChannelWs
  def initialize(ws_channel)
    @ws_channel = ws_channel
  end

  def send_message(message)
    payload = build_payload(message)
    ActionCable.server.broadcast(@ws_channel, payload)
  end

  private
    def build_payload(message)
      {
        action: 'new_message',
        channel: message.channel.push_event_data,
        content: message.push_event_data
      }
    end
end
