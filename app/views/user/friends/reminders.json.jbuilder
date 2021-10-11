# frozen_string_literal: true

json.array! @remindings do |reminding|
  json.name reminding.reminder.name
  json.goal reminding.goal.strftime('%Y.%m.%d %H:%M')
  json.created_at reminding.created_at.strftime('%Y.%m.%d %H:%M')
end
