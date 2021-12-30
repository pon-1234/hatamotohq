# frozen_string_literal: true

json.data do
  json.array! @channels do |channel|
    json.(channel, :id, :title, :locked, :line_friend_id, :last_message, :last_activity_at, :last_seen_at)
    json.unread_count channel.unread_messages.count
    json.line_friend do
      json.partial! 'models/friend', friend: channel.line_friend
    end
  end
end
