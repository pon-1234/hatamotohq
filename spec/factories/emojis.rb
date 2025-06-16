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
FactoryBot.define do
  factory :emoji do
    sequence :line_emoji_id, (52002734..52002773).to_a.cycle
    package_id { 11537 }
  end
end
