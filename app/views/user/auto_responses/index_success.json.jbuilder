# frozen_string_literal: true

json.array! @folders do |folder|
  json.(folder, :id, :name)
  json.auto_responses do
    json.array! folder.auto_responses do |auto_response|
      json.(auto_response, :id, :folder_id, :name)
      json.created_at auto_response.created_at.strftime('%Y-%m-%d %H:%M')
    end
  end
end
