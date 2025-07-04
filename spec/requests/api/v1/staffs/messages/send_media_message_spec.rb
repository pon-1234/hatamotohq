# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'POST /api/v1/staff/channels/:channel_id/messages', type: :request do
  include_examples 'create common data' # follow data has been created: agency, client, admin, staff, access_token

  let(:line_account) { FactoryBot.create(:line_account, client: client) }
  let(:line_friend) { FactoryBot.create(:line_friend, line_account: line_account) }
  let :channel do
    FactoryBot.create(:channel, line_account: line_account, line_friend: line_friend,
      assignee_id: staff.id)
  end
  let!(:media) { FactoryBot.create(:media, line_account: line_account) }
  let(:endpoint_url) { '/api/v1/staff/channels/%s/messages' % channel.id }
  let(:request_params) { { message: { type: 'image', originalContentUrl: media.url,
    previewImageUrl: media.preview_url }, format: :json }}

  include_examples 'check authorization'

  context "don't have permission for sending media message" do
    before do
      channel.update assignee_id: nil
      post endpoint_url, headers: { 'Authorization' => access_token }, params: request_params
    end

    it { expect(response.status).to eq(403) }
    it { expect(JSON.parse(response.body)['status']).to eq 'error' }
    it { expect(JSON.parse(response.body)['message']).to eq 'Permission denied' }
  end

  context 'server error has been happend' do
    before do
      allow_any_instance_of(Api::V1::Staff::MessagesController).to(receive(:push_message_to_line)
        .and_raise(ActiveRecord::StaleObjectError))
      post endpoint_url, headers: { 'Authorization' => access_token }, params: request_params
    end

    it { expect(response.status).to eq(400) }
    it { expect(JSON.parse(response.body)['message']).to eq 'Stale object error.' }
  end

  context 'send text message successfully' do
    before do
      allow_any_instance_of(LineApi::PushMessage).to(receive(:perform)
        .with([an_instance_of(Hash)], an_instance_of(String)).and_return('sent'))
      post endpoint_url, headers: { 'Authorization' => access_token }, params: request_params
    end

    it { expect(response.status).to eq(200) }
    it { expect(JSON.parse(response.body)['status']).to eq 'sent' }
  end
end
