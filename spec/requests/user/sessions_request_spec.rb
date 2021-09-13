# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'User::Sessions', type: :request do
  let(:user) { FactoryBot.create(:user) }

  it 'redirect to sign in page if not login yet' do
    get user_root_path
    expect(response).to redirect_to(new_user_session_path)
  end
end
