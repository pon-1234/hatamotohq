# frozen_string_literal: true

json.meta do
  json.total_pages @messages.total_pages
  json.current_page @messages.current_page
  json.total_count @messages.total_count
  json.limit_value @messages.limit_value
end

json.data do
  json.array! @messages do |message|
    json.id message.id
    json.line_message_id message.line_message_id
    json.line_timestamp message.line_timestamp
    json.line_content message.line_content
  end
end
