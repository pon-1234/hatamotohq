# frozen_string_literal: true

json.array! @action_objects do |action_object|
  json.id action_object.id
  json.type action_object.type
  json.description action_object.description
  json.title action_object.title
  json.format action_object.format
end
