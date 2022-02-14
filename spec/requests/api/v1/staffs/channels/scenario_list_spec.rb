# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'GET /api/v1/staff/channels/:channel_id/scenarios', type: :request do
  include_examples 'check authorization'
  include_examples 'create common data' # follow data has been created: agency, client, admin, staff, access_token

  let(:line_account) { FactoryBot.create(:line_account, client: client) }
  let(:line_friend) { FactoryBot.create(:line_friend, line_account: line_account) }
  let :channel do
    FactoryBot.create(:channel, line_account: line_account, line_friend: line_friend,
      assignee_id: staff.id)
  end
  let!(:folder) { line_account.folders.type_scenario.first }
  let!(:scenario) { FactoryBot.create(:scenario, line_account: line_account, folder_id: folder.id) }
  let(:endpoint_url) { scenarios_api_v1_staff_channel_path(channel.id) }
  let(:expectation_scenario_list) { [
    scenario.as_json(only: [:id, :title, :description, :mode, :status, :type, :scenario_messages_count,
      :after_action], methods: [:running_count, :finished_count]).merge('tags' => [])
  ]}

  context "don't have permission for get scenario list" do
    before do
      channel.update assignee_id: nil
      get endpoint_url, headers: { 'Authorization' => access_token }, params: { format: :json }
    end

    it { expect(response.status).to eq(403) }
    it { expect(JSON.parse(response.body)['status']).to eq 'error' }
    it { expect(JSON.parse(response.body)['message']).to eq 'Permission denied' }
  end

  context 'Get scenario list successfully' do
    before do
      get endpoint_url, headers: { 'Authorization' => access_token }, params: { format: :json }
    end

    it { expect(response.status).to eq(200) }
    it { expect(JSON.parse(response.body)).to eq expectation_scenario_list }
  end
end
