# frozen_string_literal: true

json.array! @folders do |folder|
  json.(folder, :id, :name)
  json.stream_routes do
    json.array! folder.stream_routes do |stream_route|
      json.(stream_route, :id, :folder_id, :name, :actions, :run_add_friend_actions, :stream_route_url, :qr_title, :created_at)
      json.friend_count stream_route.line_friends.count
    end
  end
end
