# frozen_string_literal: true

json.meta do
  json.total_pages @announcements.total_pages
  json.current_page @announcements.current_page
  json.total_count @announcements.total_count
  json.limit_value @announcements.limit_value
end
json.data do
  json.array! @announcements do |announcement|
    json.partial! 'models/announcement', announcement: announcement
  end
end
