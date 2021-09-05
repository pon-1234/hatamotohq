# frozen_string_literal: true

json.meta do
  json.total_pages @channels.total_pages
  json.current_page @channels.current_page
  json.total_count @channels.total_count
  json.limit_value @channels.limit_value
end
json.data do
  json.array! @channels do |channel|
    json.(channel, :id, :title, :status, :line_friend_id, :last_message, :last_activity_at, :un_read)
  end
end
