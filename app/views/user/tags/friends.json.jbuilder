# frozen_string_literal: true

json.array! @friends do |friend|
  json.id friend.id
end
