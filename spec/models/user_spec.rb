require 'rails_helper'

RSpec.describe User, type: :model do
  it 'authentication token was generated after create user' do
    user = User.create(email: 'example@example.com', password: 'password')
    expect(user.authentication_token).to_not be_nil
    expect(user.authentication_token.length).to eq(64)
  end
end
