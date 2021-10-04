# frozen_string_literal: true

json.(@friend, :id, :line_name, :line_picture_url, :display_name, :note, :locked, :visible)
json.created_at @friend.created_at.strftime('%Y-%m-%d %H:%M')
json.channel @friend.channel, :id, :alias, :avatar
json.tags do
  json.array! @friend.tags do |tag|
    json.(tag, :id, :name)
  end
end
