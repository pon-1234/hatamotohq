# frozen_string_literal: true

json.array! @folders do |folder|
  json.(folder, :id, :name)
  json.templates do
    json.array! folder.templates do |template|
      json.(template, :id, :folder_id, :name)
      json.created_at template.created_at.strftime('%Y-%m-%d %H:%M')
      json.messages do
        json.array! template.template_messages do |message|
          json.(message, :id, :content)
        end
      end
    end
  end
end
