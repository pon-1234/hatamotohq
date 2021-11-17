# frozen_string_literal: true

json.meta do
  json.total_pages @answered_users.total_pages
  json.current_page @answered_users.current_page
  json.total_count @answered_users.total_count
  json.limit_value @answered_users.limit_value
end

json.data do
  json.array! @answered_users do |user|
    json.id user.id
    json.display_name user.display_name
    json.avatar_url user.avatar_url
    json.responses_count user.responses_count_for(@survey.id)
  end
end
