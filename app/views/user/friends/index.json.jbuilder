# frozen_string_literal: true

json.meta do
  json.total_pages @friends.total_pages
  json.current_page @friends.current_page
  json.total_count @friends.total_count
  json.limit_value @friends.limit_value
end
json.data do
  json.array! @friends do |friend|
    json.partial! 'models/friend', friend: friend
  end
end
