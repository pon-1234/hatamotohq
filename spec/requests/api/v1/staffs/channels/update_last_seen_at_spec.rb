# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'POST /api/v1/staff/channels/:id/update_last_seen', type: :request do
  include_examples 'check authorization'
  include_examples 'create common data' # follow data has been created: agency, client, admin, staff, access_token

  let(:line_account) { FactoryBot.create(:line_account, client: client) }
  let(:line_friend) { FactoryBot.create(:line_friend, line_account: line_account) }
  let! :channel do
    FactoryBot.create(:channel, line_account: line_account, line_friend: line_friend,
      assignee_id: staff.id)
  end
  let(:endpoint_url) { update_last_seen_api_v1_staff_channel_path(channel.id) }

  context "don't have permission for updating last_seen_at" do
    before do
      channel.update assignee_id: nil
      post endpoint_url, headers: { 'Authorization' => access_token }, params: { format: :json }
    end

    it { expect(response.status).to eq(403) }
    it { expect(JSON.parse(response.body)['status']).to eq 'error' }
    it { expect(JSON.parse(response.body)['message']).to eq 'Permission denied' }
  end

  context 'Update last_seen_at successfully' do
    before do
      channel.update last_seen_at: 5.hours.ago
      post endpoint_url, headers: { 'Authorization' => access_token }, params: { format: :json }
    end

    it { expect(response.status).to eq(200) }
    it { expect(JSON.parse(response.body)['status']).to eq('success') }
    it { expect(Channel.last.last_seen_at).to_not eq @last_seen_at }
  end
end
