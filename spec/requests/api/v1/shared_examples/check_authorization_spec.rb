# frozen_string_literal: true

require 'rails_helper'

RSpec.shared_examples 'check authorization' do
  let(:logout_endpoint_url) { '/api/v1/staff/logout' }
  let(:logout_agency) { FactoryBot.create(:agency) }
  let(:logout_client) { FactoryBot.create(:client, agency: logout_agency) }
  let(:logout_user) { FactoryBot.create(:user, client: logout_client, is_admin: false) }
  let(:logout_access_token) { Common::JwtProcessor.encode({ staff_id: logout_user.id }) }
  context 'access_token is not present' do
    before do
      delete logout_endpoint_url
    end

    it { expect(response.status).to eq(403) }
    it { expect(JSON.parse(response.body)['status']).to eq 'error' }
    it { expect(JSON.parse(response.body)['message']).to eq 'アクセストークンが違います。' }
  end

  context 'access_token is invalid' do
    before do
      delete logout_endpoint_url, headers: { 'Authorization' => 'abcdef' }
    end

    it { expect(response.status).to eq(403) }
    it { expect(JSON.parse(response.body)['status']).to eq 'error' }
    it { expect(JSON.parse(response.body)['message']).to eq 'アクセストークンが違います。' }
  end

  context 'Staff is not found' do
    before do
      user2 = FactoryBot.create(:user, email: 'user2@example.com', client: logout_client, is_admin: false)
      not_exist_user_access_token = Common::JwtProcessor.encode({ staff_id: user2.id })
      user2.destroy
      delete logout_endpoint_url, headers: { 'Authorization' => not_exist_user_access_token }
    end

    it { expect(response.status).to eq(403) }
    it { expect(JSON.parse(response.body)['status']).to eq 'error' }
    it { expect(JSON.parse(response.body)['message']).to eq 'アクセストークンが違います。' }
  end

  context 'already logedout' do
    before do
      logout_user
      logout_access_token
      logout_user.allowlisted_jwts.last.destroy
      delete logout_endpoint_url, headers: { 'Authorization' => logout_access_token }
    end

    it { expect(response.status).to eq(422) }
    it { expect(JSON.parse(response.body)['status']).to eq 'error' }
    it { expect(JSON.parse(response.body)['message']).to eq 'すでにログアウトしています。' }
  end
end
