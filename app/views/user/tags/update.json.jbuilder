# frozen_string_literal: true

json.(@tag, :id, :folder_id, :name)
json.friends_count @tag.friends.count
json.created_at @tag.created_at.strftime('%Y-%m-%d %H:%M')
