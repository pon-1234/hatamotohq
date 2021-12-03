# frozen_string_literal: true

# Gets images, videos, audio, and files sent by users.
class LineApi::GetContent < LineApi::BaseRequest
  def perform(message_id)
    client.get_message_content(message_id)
  end
end
