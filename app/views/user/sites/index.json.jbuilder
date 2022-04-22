# frozen_string_literal: true

json.array! @folders do |folder|
  json.(folder, :id, :name)
  json.sites do
    json.array! folder.sites do |site|
      json.(site, :id, :folder_id, :name, :url, :sending_count, :receiver_count, :visitor_count)
      json.created_at site.created_at.strftime('%Y-%m-%d %H:%M')
    end
  end
end
