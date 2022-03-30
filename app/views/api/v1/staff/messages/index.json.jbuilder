# frozen_string_literal: true

json.meta do
  json.last_seen_at @channel.last_seen_at
end
json.data do
  json.array! @messages do |message|
    json.partial! 'models/message', message: message
  end
end
