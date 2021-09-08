# frozen_string_literal: true

json.(scenario, :id, :title, :description, :mode, :status, :type, :scenario_messages_count, :after_action)
json.tags do
  json.array! scenario.tags do |tag|
    json.(tag, :id, :name)
  end
end
