# frozen_string_literal: true

json.(friend, :id, :line_picture_url, :created_at, :status, :line_name, :note, :locked, :visible)
json.name friend.name
json.avatar_url friend.avatar_url
json.created_at friend.created_at.strftime('%Y-%m-%d %H:%M')
if friend.channel.present?
  json.channel friend.channel, :id, :title
end
json.tags do
  json.array! friend.tags do |tag|
    json.(tag, :id, :name)
  end
end
