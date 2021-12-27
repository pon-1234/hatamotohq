# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'DELETE /api/v1/staff/logout', type: :request do
  let(:endpoint_url){'/api/v1/staff/logout'}
  let(:agency){FactoryBot.create(:agency)}
  let(:client){FactoryBot.create(:client, agency: agency)}
  let(:user){FactoryBot.create(:user, client: client, is_admin: false)}
  let(:access_token){Yopaz::JwtProcessor.encode({staff_id: user.id})}
  let(:not_exist_user_access_token){Yopaz::JwtProcessor.encode({staff_id: 9999})}
  

  context 'access_token is not present' do
    before do
      delete endpoint_url
    end

    it{expect(response.status).to eq(401)}
    it{expect(JSON.parse(response.body)['status']).to eq 'error'}
    it{expect(JSON.parse(response.body)['message']).to eq 'アクセストークンが違います。'}
  end

  context 'access_token is invalid' do
    before do
      delete endpoint_url, params: {access_token: 'abcdef'}
    end

    it{expect(response.status).to eq(401)}
    it{expect(JSON.parse(response.body)['status']).to eq 'error'}
    it{expect(JSON.parse(response.body)['message']).to eq 'アクセストークンが違います。'}
  end

  context 'Staff is not found' do
    before do
      delete endpoint_url, params: {access_token: not_exist_user_access_token}
    end

    it{expect(response.status).to eq(401)}
    it{expect(JSON.parse(response.body)['status']).to eq 'error'}
    it{expect(JSON.parse(response.body)['message']).to eq 'アクセストークンが違います。'}
  end

  context 'already logedout' do
    before do
      user
      access_token
      user.allowlisted_jwts.last.destroy
      delete endpoint_url, params: {access_token: access_token}
    end

    it{expect(response.status).to eq(401)}
    it{expect(JSON.parse(response.body)['status']).to eq 'error'}
    it{expect(JSON.parse(response.body)['message']).to eq 'すでにログアウトしています。'}
  end

  context 'Logout successfully' do
    before do
      delete endpoint_url, params: {access_token: access_token}
    end

    it{expect(response.status).to eq(200)}
    it{expect(JSON.parse(response.body)['status']).to eq 'success'}
  end
end
