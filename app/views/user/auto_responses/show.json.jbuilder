# frozen_string_literal: true

json.(@auto_response, :id, :folder_id, :name, :status)
json.keywords @auto_response.auto_response_keywords.pluck(:keyword)
json.messages do
  json.array! @auto_response.auto_response_messages do |message|
    json.(message, :message_type_id, :content)
  end
end
