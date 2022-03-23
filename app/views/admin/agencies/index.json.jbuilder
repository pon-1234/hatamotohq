# frozen_string_literal: true

json.meta do
  json.total_pages @agencies.total_pages
  json.current_page @agencies.current_page
  json.total_count @agencies.total_count
  json.limit_value @agencies.limit_value
end
json.data do
  json.array! @agencies do |agency|
    json.partial! 'models/agency', agency: agency
  end
end
