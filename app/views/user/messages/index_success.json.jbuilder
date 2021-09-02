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
    json.customer do
      json.id message.sender.id
      json.line_user_id message.sender.line_user_id
      json.line_name message.sender.display_name
      json.line_picture_url message.sender.line_picture_url
    end
  end
end
