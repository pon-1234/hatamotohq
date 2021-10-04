# frozen_string_literal: true

json.data do
  json.array! @channels do |channel|
    json.(channel, :id, :title, :locked, :line_friend_id, :last_message, :last_activity_at, :last_seen_at)
    json.unread_count channel.unread_messages.count
    json.line_friend do
      json.id channel.line_friend.id
      json.name channel.line_friend.name
      json.avatar_url channel.line_friend.avatar_url
      json.created_at channel.line_friend.created_at
      json.tags do
        json.array! channel.line_friend.tags do |tag|
          json.id tag.id
          json.name tag.name
        end
      end
    end
  end
end
