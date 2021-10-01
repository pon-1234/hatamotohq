# frozen_string_literal: true

json.data do
  json.array! @channels do |channel|
    json.(channel, :id, :title, :locked, :line_friend_id, :last_message, :last_activity_at)
    json.unread_count channel.unread_messages.count
    json.line_friend do
      json.id channel.line_friend.id
      json.name channel.line_friend.name
      json.avatar_url channel.line_friend.avatar_url
    end
  end
end
