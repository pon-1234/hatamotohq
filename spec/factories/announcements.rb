# frozen_string_literal: true

# == Schema Information
#
# Table name: announcements
#
#  id           :bigint           not null, primary key
#  title        :text(65535)
#  body         :text(4294967295)
#  announced_at :datetime
#  status       :string(255)
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#
FactoryBot.define do
  factory :announcement do
  end
end
