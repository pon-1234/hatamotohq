# frozen_string_literal: true

json.array! @remindings do |reminding|
  json.name reminding.reminder.name
  json.goal reminding.goal
  json.created_at reminding.created_at
  json.status reminding.status
end
