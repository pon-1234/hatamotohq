class Ws::ChannelWs
  def initialize(ws_channel)
    @ws_channel = ws_channel
  end

  def send_message(sender, message)
    payload = build_payload(sender, message)
    ActionCable.server.broadcast(@ws_channel, payload)
  end

  private
    def build_payload(sender, message)
      {
        action: 'new_message',
        channel: sender.channel.as_json(except: [:deleted_at]),
        content: {
          customer: { id: sender.id },
          is_bot_sender: 0,
          line_content: message.line_content,
          line_timestamp: message.line_timestamp
        }
      }
    end
end