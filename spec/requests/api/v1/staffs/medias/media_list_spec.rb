# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'GET /api/v1/staff/medias', type: :request do
  include_examples 'check authorization'
  include_examples 'create common data' # follow data has been created: agency, client, admin, staff, access_token

  let(:endpoint_url) { api_v1_staff_medias_path }
  let(:line_account) { FactoryBot.create(:line_account, client: client) }
  let!(:media) { FactoryBot.create :media, line_account: line_account }
  let(:expectation_media_list) { {
     'meta' => {
        'total_pages' => 1,
        'current_page' => 1,
        'total_count' => 1,
        'limit_value' => 12
      },
      'data' => [
          media.as_json(only: [:created_at, :id, :type, :duration], methods: [:url, :preview_url, :download_url, :file_name])
            .merge('duration' => media.file.blob.duration)
        ]
      }}

  context 'get media list successfully' do
    before do
      get endpoint_url, headers: { 'Authorization' => access_token }, params: { format: :json }
    end

    it { expect(response.status).to eq(200) }
    it { expect(JSON.parse(response.body)).to eq expectation_media_list }
  end
end
