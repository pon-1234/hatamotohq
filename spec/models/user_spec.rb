# frozen_string_literal: true

# == Schema Information
#
# Table name: users
#
#  id                     :bigint           not null, primary key
#  client_id              :bigint
#  email                  :string(255)      default(""), not null
#  role                   :string(255)
#  encrypted_password     :string(255)      default(""), not null
#  name                   :string(255)
#  company_name           :string(255)
#  phone_number           :string(255)
#  address                :string(255)
#  note                   :text(65535)
#  status                 :string(255)      default("active")
#  reset_password_token   :string(255)
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer          default(0), not null
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :string(255)
#  last_sign_in_ip        :string(255)
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  authentication_token   :string(255)
#  pubsub_token           :string(255)
#
# Indexes
#
#  index_users_on_authentication_token  (authentication_token) UNIQUE
#  index_users_on_client_id             (client_id)
#  index_users_on_email                 (email) UNIQUE
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (client_id => clients.id)
#
require 'rails_helper'

RSpec.describe User, type: :model do
  it 'authentication token was generated after create user' do
    user = User.create(email: 'example@example.com', password: 'password')
    expect(user.authentication_token).to_not be_nil
    expect(user.authentication_token.length).to eq(64)
  end
end
