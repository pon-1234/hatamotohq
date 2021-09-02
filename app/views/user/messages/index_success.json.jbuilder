# frozen_string_literal: true

json.meta do
  json.total_pages @messages.total_pages
  json.current_page @messages.current_page
  json.total_count @messages.total_count
  json.limit_value @messages.limit_value
end

json.data do
  json.array! @messages do |message|
    json.(message, :id, :line_message_id, :line_timestamp, :line_content, :from)
  end
end
