# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'POST /api/v1/staff/login', type: :request do
  let(:endpoint_url){'/api/v1/staff/login'}
  let(:agency){FactoryBot.create(:agency)}
  let(:client){FactoryBot.create(:client, agency: agency)}
  let(:user){FactoryBot.create(:user, client: client, is_admin: false)}
  

  context 'Email is not present' do
    before do
      post endpoint_url, params: {email: '', password: 'admin1234'}
    end

    it{expect(response.status).to eq(401)}
    it{expect(JSON.parse(response.body)['status']).to eq 'error'}
    it{expect(JSON.parse(response.body)['message']).to eq 'メールアドレスまたはパスワードが違います。'}
  end

  context 'Password is not present' do
    before do
      post endpoint_url, params: {email: user.email, password: ''}
    end

    it{expect(response.status).to eq(401)}
    it{expect(JSON.parse(response.body)['status']).to eq 'error'}
    it{expect(JSON.parse(response.body)['message']).to eq 'メールアドレスまたはパスワードが違います。'}
  end

  context 'Staff is not found' do
    before do
      post endpoint_url, params: {email: 'fakeemail@example.com', password: 'admin1234'}
    end

    it{expect(response.status).to eq(401)}
    it{expect(JSON.parse(response.body)['status']).to eq 'error'}
    it{expect(JSON.parse(response.body)['message']).to eq 'メールアドレスまたはパスワードが違います。'}
  end

  context 'Password is invalid' do
    before do
      post endpoint_url, params: {email: user.email, password: 'failurepassword'}
    end

    it{expect(response.status).to eq(401)}
    it{expect(JSON.parse(response.body)['status']).to eq 'error'}
    it{expect(JSON.parse(response.body)['message']).to eq 'メールアドレスまたはパスワードが違います。'}
  end

  context 'Email and password are valid' do
    before do
      post endpoint_url, params: {email: user.email, password: 'admin1234'}
    end

    it{expect(response.status).to eq(200)}
    it{expect(JSON.parse(response.body)['status']).to eq 'success'}
    it{expect(JSON.parse(response.body)['data']['accessToken']).to be_a(String)}
  end
end
