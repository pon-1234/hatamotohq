# frozen_string_literal: true

# == Schema Information
#
# Table name: media
#
#  id              :bigint           not null, primary key
#  alias           :string(255)
#  type            :string(255)
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  line_account_id :bigint
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
