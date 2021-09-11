# frozen_string_literal: true

json.(broadcast, :id, :title, :type, :deliver_now, :schedule_at, :conditions)
json.tags do
  json.array! broadcast.tags do |tag|
    json.partial! 'models/tag', tag: tag
  end
end
json.messages do
  json.array! broadcast.broadcast_messages do |message|
    json.(message, :id, :message_type_id, :content)
  end
end
