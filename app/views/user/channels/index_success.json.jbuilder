json.meta do
  json.total_pages @channels.total_pages
  json.current_page @channels.current_page
  json.total_count @channels.total_count
  json.limit_value @channels.limit_value
end
json.data do
  json.array! @channels do |channel|
    json.(channel, :id, :title, :status)
    json.line_friend_id 1
    json.last_message 'xxxxx'
    json.last_timetamp '2021-08-27 17:00:00'
    json.unread 0
  end
end