# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'POST /api/v1/staff/channels/:channel_id/messages/send_scenario', type: :request do
  include_examples 'create common data' # follow data has been created: agency, client, admin, staff, access_token

  let(:line_account) { FactoryBot.create(:line_account, client: client) }
  let(:line_friend) { FactoryBot.create(:line_friend, line_account: line_account) }
  let :channel do
    FactoryBot.create(:channel, line_account: line_account, line_friend: line_friend,
      assignee_id: staff.id)
  end
  let!(:folder) { line_account.folders.type_scenario.first }
  let!(:scenario) { FactoryBot.create(:scenario, line_account: line_account, folder_id: folder.id) }
  let(:endpoint_url) { send_scenario_api_v1_staff_channel_messages_path(channel_id: channel.id) }

  include_examples 'check authorization'

  context "don't have permission for sending a scenario" do
    before do
      channel.update assignee_id: nil
      post endpoint_url, headers: { 'Authorization' => access_token }, params: { scenario_id: scenario.id, format: :json }
    end

    it { expect(response.status).to eq(403) }
    it { expect(JSON.parse(response.body)['status']).to eq 'error' }
    it { expect(JSON.parse(response.body)['message']).to eq 'Permission denied' }
  end

  context 'send a scenario successfully' do
    before do
      post endpoint_url, headers: { 'Authorization' => access_token },
        params: { scenario_id: scenario.id, format: :json }
    end

    it { expect(response.status).to eq(200) }
    it { expect(JSON.parse(response.body)['status']).to eq 'success' }
  end
end
