# frozen_string_literal: true

json.array! @action_objects do |action_object|
  json.(action_object, :id, :type, :description, :format)
end
