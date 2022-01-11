# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'GET /api/v1/staff/channels/:channel_id/messages', type: :request do
  include_examples 'check authorization'
  include_examples 'create common data' # follow data has been created: agency, client, admin, staff, access_token

  let(:line_account) { FactoryBot.create(:line_account, client: client) }
  let(:line_friend) { FactoryBot.create(:line_friend, line_account: line_account) }
  let :channel do
    FactoryBot.create(:channel, line_account: line_account, line_friend: line_friend,
      assignee_id: staff.id)
  end
  let!(:message) { FactoryBot.create(:message, channel: channel, sender: staff) }
  let(:endpoint_url) { api_v1_staff_channel_messages_path(channel_id: channel.id) }

  let(:expectation_messages) {
    [
      message.as_json(only: %i(id timestamp text content html_content from status))
        .merge('sender' => staff.as_json(only: %i(id name), methods: %i(avatar_url)))
    ]
  }

  context 'get message list successfully' do
    before do
      get endpoint_url, headers: { 'Authorization' => access_token }, params: { format: :json }
    end

    it { expect(response.status).to eq(200) }
    it { expect(JSON.parse(response.body)['data']).to eq expectation_messages }
    it { expect(JSON.parse(response.body)['meta']['last_seen_at']).to be_a String }
  end
end
