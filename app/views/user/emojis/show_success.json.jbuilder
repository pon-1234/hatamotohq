# frozen_string_literal: true

json.array! @emojis do |emoji|
  json.id emoji.id
  json.package_id emoji.package_id
  json.line_emoji_id emoji.line_emoji_id
end
