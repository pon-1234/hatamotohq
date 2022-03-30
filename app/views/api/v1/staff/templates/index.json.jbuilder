# frozen_string_literal: true

json.array! @folders do |folder|
  json.(folder, :id, :name)
  json.templates do
    json.array! folder.templates do |template|
      json.(template, :id, :folder_id, :name, :template_messages_count)
      json.created_at template.created_at.strftime('%Y-%m-%d %H:%M')
    end
  end
end
