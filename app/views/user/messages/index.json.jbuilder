# frozen_string_literal: true

json.meta do
  json.total_pages @messages.total_pages
  json.current_page @messages.current_page
  json.total_count @messages.total_count
  json.limit_value @messages.limit_value
end

json.data do
  json.array! @messages do |message|
    json.partial! 'models/message', message: message
  end
end
