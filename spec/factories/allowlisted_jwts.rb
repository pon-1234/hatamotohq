# frozen_string_literal: true

# == Schema Information
#
# Table name: allowlisted_jwts
#
#  id         :bigint           not null, primary key
#  jti        :string(255)
#  exp        :datetime
#  user_id    :bigint           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_allowlisted_jwts_on_jti      (jti) UNIQUE
#  index_allowlisted_jwts_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
FactoryBot.define do
  factory :allowlisted_jwt do
    jti { 'MyString' }
    ext { '2021-12-24 10:31:36' }
    user { nil }
  end
end
