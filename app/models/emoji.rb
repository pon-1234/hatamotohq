# frozen_string_literal: true

# == Schema Information
#
# Table name: emojis
#
#  id            :bigint           not null, primary key
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  line_emoji_id :string(255)
#  package_id    :string(255)
#
class Emoji < ApplicationRecord
end
