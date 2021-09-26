# frozen_string_literal: true

json.meta do
  json.total_pages @scenarios.total_pages
  json.current_page @scenarios.current_page
  json.total_count @scenarios.total_count
  json.limit_value @scenarios.limit_value
end
json.data do
  json.array! @scenarios do |scenario|
    json.partial! 'models/scenario', scenario: scenario
  end
end
