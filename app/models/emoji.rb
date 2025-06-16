# frozen_string_literal: true

# == Schema Information
#
# Table name: emojis
#
#  id            :bigint           not null, primary key
#  package_id    :string
#  line_emoji_id :string
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#
class Emoji < ApplicationRecord
  scope :by_pack, -> (pack_id) { where(package_id: pack_id) }
end
