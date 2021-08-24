# frozen_string_literal: true

packages = [
  {
    id: 11537,
    start: 52002734,
    end: 52002773
  },
  {
    id: 11538,
    start: 51626494,
    end: 51626533
  },
  {
    id: 11539,
    start: 52114110,
    end: 52114149
  }
]

emojis = []
index = 1
packages.each do |package|
  (package[:start]..package[:end]).each do |id|
    emoji = {
      id: index,
      package_id: package[:id],
      line_emoji_id: id
    }
    emojis << emoji
    index += 1
  end
end
Emoji.import! emojis
