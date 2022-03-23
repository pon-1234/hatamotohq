# frozen_string_literal: true

json.meta do
  json.total_pages @clients.total_pages
  json.current_page @clients.current_page
  json.total_count @clients.total_count
  json.limit_value @clients.limit_value
end
json.data do
  json.array! @clients do |client|
    json.partial! 'models/client', client: client
  end
end
