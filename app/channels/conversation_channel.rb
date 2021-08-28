class ConversationChannel < ApplicationCable::Channel
  def subscribed
    ensure_stream
    current_user
  end

  def ensure_stream
    @pubsub_token = params[:pubsub_token]
    stream_from @pubsub_token
  end

  def current_user
    @current_user ||= User.find_by!(pubsub_token: @pubsub_token)
  end
end
