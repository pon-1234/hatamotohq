# frozen_string_literal: true

json.array! @reminders do |reminder|
  json.id reminder.id
  json.name reminder.name
end
