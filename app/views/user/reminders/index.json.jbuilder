# frozen_string_literal: true

json.array! @folders do |folder|
  json.(folder, :id, :name)
  json.reminders do
    json.array! folder.reminders do |reminder|
      json.(reminder, :id, :folder_id, :name, :episodes_count)
      json.destroyable reminder.destroyable?
      json.created_at reminder.created_at
    end
  end
end
