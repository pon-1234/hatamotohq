json.id @friend.id
json.line_name @friend.line_name
json.line_picture_url @friend.line_picture_url
json.display_name @friend.display_name
json.note @friend.note
json.channel do
  json.id @friend.channel.id
  json.alias @friend.channel.alias
  json.avatar @friend.channel.avatar
end
json.status @friend.status
json.created_at @friend.created_at.strftime('%Y-%m-%d %H:%M')