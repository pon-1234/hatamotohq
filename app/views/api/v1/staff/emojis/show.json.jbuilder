# frozen_string_literal: true

json.array! @emojis do |emoji|
  json.(emoji, :id, :package_id, :line_emoji_id)
end
