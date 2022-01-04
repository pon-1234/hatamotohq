# frozen_string_literal: true

json.meta do
  json.total_pages @medias.total_pages
  json.current_page @medias.current_page
  json.total_count @medias.total_count
  json.limit_value @medias.limit_value
end
json.data do
  json.array! @medias do |media|
    json.partial! 'models/media', media: media
  end
end
