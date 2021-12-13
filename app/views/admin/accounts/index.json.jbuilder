# frozen_string_literal: true

json.meta do
  json.total_pages @accounts.total_pages
  json.current_page @accounts.current_page
  json.total_count @accounts.total_count
  json.limit_value @accounts.limit_value
end
json.data do
  json.array! @accounts do |account|
    json.partial! 'models/account', account: account
  end
end
