# frozen_string_literal: true

json.(line_friend, :id, :line_picture_url, :line_name, :created_at, :status)
json.tags do
  json.array! line_friend.tags do |tag|
    json.(tag, :id, :name)
  end
end
