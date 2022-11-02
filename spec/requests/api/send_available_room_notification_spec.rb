# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'POST /reservations/callback/:uid', type: :request do
  let(:agency) { FactoryBot.create(:agency) }
  let(:client) { FactoryBot.create(:client, agency: agency) }
  let(:line_account) { FactoryBot.create(:line_account, client: client) }
  let(:line_friend) { FactoryBot.create(:line_friend, line_account: line_account) }
  let!(:notifier_id) { SecureRandom.alphanumeric(32) }
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
      "plans": [
        {
          "plan_name": 'Plan 1',
          "plan_calendar": [
            {
              "date": '2022-01-01',
              "price": 26000,
              "stock": 1
            }
          ]
        }
      ],
      "type_id": 20,
      "type_name": 'type name',
      "ota_url": 'https://sample_holtel.com'
    }
  }
  let! :reservation do
    FactoryBot.create :reservation, line_friend_id: line_friend.id, room_id: params[:type_id],
      notifier_id: notifier_id, line_account_id: line_account.id
  end
  let(:endpoint_url) { "/reservations/callback/?notifierId=#{notifier_id}" }

  context 'when type_id is blank' do
    before do
      params[:type_id] = nil
      post endpoint_url, params: params
    end

    it { expect(response.status).to eq(400) }
    it { expect(JSON.parse(response.body)['status']).to eq 'error' }
    it { expect(JSON.parse(response.body)['message']).to end_with 'を入力してください' }
  end

  context 'when notifier_id is blank' do
    before do
      post '/reservations/callback', params: params
    end

    it { expect(response.status).to eq(400) }
    it { expect(JSON.parse(response.body)['status']).to eq 'error' }
    it { expect(JSON.parse(response.body)['message']).to end_with 'を入力してください' }
  end

  context 'when available_room_count is blank' do
    before do
      params[:plans][0][:plan_calendar][0][:stock] = nil
      post endpoint_url, params: params
    end

    it { expect(response.status).to eq(400) }
    it { expect(JSON.parse(response.body)['status']).to eq 'error' }
    it { expect(JSON.parse(response.body)['message']).to end_with 'を入力してください' }
  end

  context 'when available_room_count is not valid' do
    before do
      params[:plans][0][:plan_calendar][0][:stock] = -1
      post endpoint_url, params: params
    end

    it { expect(response.status).to eq(400) }
    it { expect(JSON.parse(response.body)['status']).to eq 'error' }
    it { expect(JSON.parse(response.body)['message']).to eq '在庫中数は0より大きい値にしてください' }
  end

  context 'when has no available room' do
    before do
      params[:plans][0][:plan_calendar][0][:stock] = 0
      post endpoint_url, params: params
    end

    it { expect(response.status).to eq(400) }
    it { expect(JSON.parse(response.body)['status']).to eq 'error' }
    it { expect(JSON.parse(response.body)['message']).to eq '在庫中数は0より大きい値にしてください' }
  end

  context 'when has no room bookmark' do
    before do
      params[:type_id] = 2000
      post endpoint_url, params: params
    end

    it { expect(response.status).to eq(400) }
    it { expect(JSON.parse(response.body)['status']).to eq 'error' }
    it { expect(JSON.parse(response.body)['message']).to eq 'キャンセル待ちしている部屋が見つかりませんでした。' }
  end

  context 'when send available room notification successfully' do
    before do
      post endpoint_url, params: params
    end

    it { expect(response.status).to eq(200) }
    it { expect(JSON.parse(response.body)['status']).to eq 'success' }
  end
end
