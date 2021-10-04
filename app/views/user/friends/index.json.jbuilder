# frozen_string_literal: true

json.meta do
  json.total_pages @line_friends.total_pages
  json.current_page @line_friends.current_page
  json.total_count @line_friends.total_count
  json.limit_value @line_friends.limit_value
end
json.data do
  json.array! @line_friends do |line_friend|
    json.partial! 'models/line_friend', line_friend: line_friend
  end
end
