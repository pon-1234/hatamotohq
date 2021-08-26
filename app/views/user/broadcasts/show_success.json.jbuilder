# frozen_string_literal: true

json.id @broadcast.id
json.title @broadcast.title
json.deliver_now @broadcast.deliver_now
json.conditions @broadcast.conditions
json.tag_ids @broadcast.tag_ids
json.broadcast_messages do
  json.array! @broadcast.broadcast_messages do |message|
    json.id message.id
    json.message_type_id message.message_type_id
    json.content message.content
  end
end
