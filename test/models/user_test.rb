require 'test_helper'

class UserTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
  test "authentication token was generated after create user" do
    user = User.create(email: 'example@example.com', password: 'password')
    assert user.authentication_token
  end
end
