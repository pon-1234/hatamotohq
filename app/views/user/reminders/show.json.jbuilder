# frozen_string_literal: true

json.(@reminder, :id, :folder_id, :name)
json.episodes do
  json.array! @reminder.episodes do |episode|
    json.partial! 'models/episode', episode: episode
  end
end
