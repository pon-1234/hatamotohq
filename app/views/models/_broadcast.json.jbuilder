# frozen_string_literal: true

json.(broadcast, :id, :title, :type, :status, :deliver_now, :schedule_at, :conditions)
json.tags do
  json.array! broadcast.tags do |tag|
    json.partial! 'models/tag', tag: tag
  end
end
json.messages do
  json.array! broadcast.broadcast_messages do |message|
    json.(message, :id, :message_type_id, :content)
    json.site_measurements do
      json.array! message.site_measurements, :id, :actions, :site_id, :site_name, :redirect_url
    end
  end
end
