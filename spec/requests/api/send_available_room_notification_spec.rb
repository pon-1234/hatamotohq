# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'POST /reservations/callback/:uid', type: :request do
  let(:agency) { FactoryBot.create(:agency) }
  let(:client) { FactoryBot.create(:client, agency: agency) }
  let(:line_account) { FactoryBot.create(:line_account, client: client) }
  let(:line_friend) { FactoryBot.create(:line_friend, line_account: line_account) }
  let!(:uid) { SecureRandom.alphanumeric(32) }
  let!(:params) {
    {
      "non_smoking": true,
      "pax_max": 1,
      "pax_min": 2,
      "price_calendar": [
        {
          "date": '2022-01-01',
          "price": 46000
        }
      ],
      "room_area": {
        "value": 2,
        "unit": 'sample unit'
      },
      "room_photos": [
        'https://samplephoto.jpg'
      ],
      "stock_calendar": [
        {
          "date": '2022-01-01',
          "stock": 1
        }
      ],
      "type_id": 20,
      "type_name": 'type name',
      "ota_url": 'https://sample_holtel.com'
    }
  }
  let! :reservation do
    FactoryBot.create :reservation, line_friend_id: line_friend.id, room_id: params[:type_id],
      callback_url: uid, line_account_id: line_account.id
  end
  let(:access_token) { "Bearer #{ENV['CRM_API_KEY']}" }
  let(:endpoint_url) { "/reservations/callback/#{uid}" }

  context 'when type_id is blank' do
    before do
      params['type_id'] = nil
      post endpoint_url, params: params, headers: { 'Authorization' => access_token }
    end

    it { expect(response.status).to eq(400) }
    it { expect(JSON.parse(response.body)['status']).to eq 'error' }
    it { expect(JSON.parse(response.body)['message']).to end_with 'を入力してください' }
  end

  context 'when access_token is blank' do
    before do
      post endpoint_url, params: params, headers: { 'Authorization' => nil }
    end

    it { expect(response.status).to eq(400) }
    it { expect(JSON.parse(response.body)['status']).to eq 'error' }
    it { expect(JSON.parse(response.body)['message']).to end_with 'を入力してください' }
  end

  context 'access_token is incorrect' do
    before do
      access_token = 'incorrect_token'
      post endpoint_url, params: params, headers: { 'Authorization' => access_token }
    end

    it { expect(response.status).to eq(400) }
    it { expect(JSON.parse(response.body)['status']).to eq 'error' }
    it { expect(JSON.parse(response.body)['message']).to eq 'APIキーが違います' }
  end

  context 'when has no available room' do
    before do
      params[:stock_calendar][0][:stock] = 0
      post endpoint_url, params: params, headers: { 'Authorization' => access_token }
    end

    it { expect(response.status).to eq(400) }
    it { expect(JSON.parse(response.body)['status']).to eq 'error' }
    it { expect(JSON.parse(response.body)['message']).to eq '空室の数は0より大きい値にしてください' }
  end

  context 'when has no room bookmark' do
    before do
      params[:type_id] = 2000
      post endpoint_url, params: params, headers: { 'Authorization' => access_token }
    end

    it { expect(response.status).to eq(400) }
    it { expect(JSON.parse(response.body)['status']).to eq 'error' }
    it { expect(JSON.parse(response.body)['message']).to eq 'ルームブックマークがありません' }
  end

  context 'when send available room notification successfully' do
    before do
      post endpoint_url, params: params, headers: { 'Authorization' => access_token }
    end

    it { expect(response.status).to eq(200) }
    it { expect(JSON.parse(response.body)['status']).to eq 'success' }
  end
end
