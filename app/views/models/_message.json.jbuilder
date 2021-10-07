# frozen_string_literal: true

json.(message, :id, :line_message_id, :timestamp, :text, :content, :from, :status)
if message.sender.present?
  json.sender do
    json.id message.sender.id
    json.name message.sender.name
    json.avatar_url message.sender.avatar_url
  end
end
