# frozen_string_literal: true

# == Schema Information
#
# Table name: media
#
#  id              :bigint           not null, primary key
#  line_account_id :bigint
#  type            :string(255)
#  provider        :string(255)      default("system")
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
# Indexes
#
#  index_media_on_line_account_id  (line_account_id)
#
# Foreign Keys
#
#  fk_rails_...  (line_account_id => line_accounts.id)
#
FactoryBot.define do
  factory :media do
  end
end
