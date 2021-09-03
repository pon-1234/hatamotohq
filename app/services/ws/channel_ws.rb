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
        channel: message.channel.as_json(except: [:deleted_at]),
        content: {
          customer: { id: message.sender&.id },
          from: message.from,
          line_content: message.line_content,
          timestamp: message.timestamp
        }
      }
    end
end
