# frozen_string_literal: true

json.(@broadcast, :id, :title, :deliver_now, :conditions)
json.tag_ids @broadcast.tag_ids
json.messages do
  json.array! @broadcast.broadcast_messages do |message|
    json.(message, :id, :message_type_id, :content)
  end
end
