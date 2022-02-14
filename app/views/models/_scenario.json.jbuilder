# frozen_string_literal: true

json.(scenario, :id, :title, :description, :mode, :status, :type, :scenario_messages_count, :after_action, :running_count, :finished_count)
json.tags do
  json.array! scenario.tags do |tag|
    json.(tag, :id, :name)
  end
end
