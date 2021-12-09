# frozen_string_literal: true

json.meta do
  json.total_pages @staffs.total_pages
  json.current_page @staffs.current_page
  json.total_count @staffs.total_count
  json.limit_value @staffs.limit_value
end
json.data do
  json.array! @staffs do |staff|
    json.partial! 'models/staff', staff: staff
  end
end