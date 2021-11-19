# frozen_string_literal: true

json.array! @folders do |folder|
  json.(folder, :id, :name)
  json.variables do
    json.array! folder.variables do |variable|
      json.(variable, :id, :folder_id, :name, :type, :default, :friends_count)
      json.created_at variable.created_at.strftime('%Y-%m-%d %H:%M')
    end
  end
end
