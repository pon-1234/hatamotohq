# frozen_string_literal: true

json.(message, :id, :line_message_id, :timestamp, :line_content, :from)
json.customer do
  json.id message.sender.id
  json.name message.sender.name
  json.avatar_url message.sender.avatar_url
end
