class ConversationChannel < ApplicationCable::Channel
  def subscribed
    ensure_stream
  end

  def ensure_stream
    stream_from "channel_user_#{current_user.id}"
  end
end
