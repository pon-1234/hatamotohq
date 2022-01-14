# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'POST /api/v1/staff/medias', type: :request do
  include_examples 'check authorization'
  # follow data has been created: agency, client, admin, staff, access_token
  include_examples 'create common data'

  let!(:line_account) { FactoryBot.create(:line_account, client: client) }
  let!(:line_friend) { FactoryBot.create(:line_friend, line_account: line_account) }
  let!(:channel) do
    FactoryBot.create(:channel, line_account: line_account, line_friend: line_friend,
      assignee_id: staff.id)
  end
  let(:endpoint_url) { api_v1_staff_medias_path }

  context 'upload media file failed because of failed validation' do
    before do
      post endpoint_url, headers: { 'Authorization' => access_token },
        params: { file: fixture_file_upload(Rails.root.join('spec', 'sample_files',
        'sample_image.png'), 'image/png'), type: 'invalidtype', format: :json }
    end

    it { expect(response.status).to eq(400) }
    it { expect(JSON.parse(response.body)['message']).to eq 'タイプは一覧にありません' }
  end

  context 'upload media file successfully' do
    before do
      post endpoint_url, headers: { 'Authorization' => access_token },
        params: { file: fixture_file_upload(Rails.root.join('spec', 'sample_files',
        'sample_image.png'), 'image/png'), type: 'image', format: :json }
    end

    it { expect(response.status).to eq(200) }
    it { expect(JSON.parse(response.body).as_json(only: %w(type file_name duration)))
      .to eq({ 'type' => 'image', 'file_name' => 'sample_image.png', 'duration' => nil })}
    it { expect(%w(id url preview_url download_url).all? { |attr| JSON.parse(response.body).key?(attr) }).to be true }
  end
end
