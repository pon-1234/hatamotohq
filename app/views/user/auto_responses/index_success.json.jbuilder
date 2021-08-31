# frozen_string_literal: true

json.array! @folders do |folder|
  json.(folder, :id, :name)
  json.auto_responses do
    json.array! folder.auto_responses do |auto_response|
      json.(auto_response, :id, :folder_id, :name)
      json.created_at auto_response.created_at.strftime('%Y-%m-%d %H:%M')
      json.keywords auto_response.auto_response_keywords.map(&:keyword)
      json.messages do
        json.array! auto_response.auto_response_messages do |message|
          json.(message, :id, :message_type_id, :content)
        end
      end
    end
  end
end
