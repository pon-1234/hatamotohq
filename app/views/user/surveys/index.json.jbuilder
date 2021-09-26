# frozen_string_literal: true

json.array! @folders do |folder|
  json.(folder, :id, :name)
  json.surveys do
    json.array! folder.surveys do |survey|
      json.(survey, :id, :folder_id, :name, :status)
      json.created_at survey.created_at.strftime('%Y-%m-%d %H:%M')
    end
  end
end
