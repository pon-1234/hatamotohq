# frozen_string_literal: true

json.(friend, :id, :line_name, :note, :locked, :visible)
json.name friend.name
json.avatar_url friend.avatar_url
json.created_at friend.created_at.strftime('%Y-%m-%d %H:%M')
json.channel friend.channel, :id, :title
json.tags do
  json.array! friend.tags do |tag|
    json.(tag, :id, :name)
  end
end
