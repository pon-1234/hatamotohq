# frozen_string_literal: true

json.array! @folders do |folder|
  json.(folder, :id, :name)
  json.tags_count folder.tags.count
  json.tags do
    json.array! folder.tags do |tag|
      json.(tag, :id, :folder_id, :name)
      json.line_friend_count 0
      json.created_at tag.created_at.strftime('%Y-%m-%d %H:%M')
    end
  end
end
