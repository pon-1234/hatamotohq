# frozen_string_literal: true

json.meta do
  json.total_pages @users.total_pages
  json.current_page @users.current_page
  json.total_count @users.total_count
  json.limit_value @users.limit_value
end
json.data do
  json.array! @users do |user|
    json.partial! 'models/user', user: user
  end
end
