# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'GET /api/v1/staff/channels', type: :request do
  include_examples 'check authorization'
  include_examples 'create common data' # follow data has been created: agency, client, admin, staff, access_token

  let(:line_account) { FactoryBot.create(:line_account, client: client) }
  let(:line_friend) { FactoryBot.create(:line_friend, line_account: line_account) }
  let! :channel do
    FactoryBot.create(:channel, line_account: line_account, line_friend: line_friend,
      assignee_id: staff.id)
  end
  let(:endpoint_url) { api_v1_staff_channels_path }

  context 'Get channel list successfully' do
    before do
      get endpoint_url, headers: { 'Authorization' => access_token }, params: { format: :json }
    end

    it { expect(response.status).to eq(200) }
    it { expect(JSON.parse(response.body)['data'].first['id']).to eq channel.id }
    it { expect(JSON.parse(response.body)['data'].first['line_friend']['id']).to eq line_friend.id }
  end
end
