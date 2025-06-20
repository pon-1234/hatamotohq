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
  let(:endpoint_url) { api_v1_staff_channel_messages_path(channel_id: channel.id) }

  let :message_content do
    { message: { type: 'sticker', packageId: emoji.package_id, stickerId: emoji.line_emoji_id, stickerResourceType: 'STATIC' },
      format: :json }
  end

  let!(:emoji) { FactoryBot.create(:emoji) }

  include_examples 'check authorization'

  context "don't have permission for sending emoji message" do
    before do
      channel.update assignee_id: nil
      post endpoint_url, headers: { 'Authorization' => access_token }, params: message_content
    end

    it { expect(response.status).to eq(403) }
    it { expect(JSON.parse(response.body)['status']).to eq 'error' }
    it { expect(JSON.parse(response.body)['message']).to eq 'Permission denied' }
  end

  context 'server error has been happend' do
    before do
      allow_any_instance_of(Api::V1::Staff::MessagesController).to(receive(:push_message_to_line)
        .and_raise(ActiveRecord::StaleObjectError))
      post endpoint_url, headers: { 'Authorization' => access_token }, params: message_content
    end

    it { expect(response.status).to eq(400) }
    it { expect(JSON.parse(response.body)['message']).to eq 'Stale object error.' }
  end

  context 'send an emoji message successfully' do
    before do
      allow_any_instance_of(LineApi::PushMessage).to(receive(:perform)
        .with([an_instance_of(Hash)], an_instance_of(String)).and_return('sent'))
      post endpoint_url, headers: { 'Authorization' => access_token }, params: message_content
    end

    it { expect(response.status).to eq(200) }
    it { expect(JSON.parse(response.body)['text']).to eq('スタンプを送信しました') }
    it { expect(JSON.parse(response.body)['content']['type']).to eq('sticker') }
    it { expect(JSON.parse(response.body)['status']).to eq 'sent' }
  end
end
