# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'GET /api/v1/staff/emojis/:pack_id', type: :request do  
  include_examples 'check authorization'

  let(:agency){FactoryBot.create(:agency)}
  let(:client){FactoryBot.create(:client, agency: agency)}
  let!(:admin){FactoryBot.create(:user, client: client, is_admin: true)}
  let(:staff){FactoryBot.create(:user, client: client, is_admin: false)}
  let(:access_token){Common::JwtProcessor.encode({staff_id: staff.id})}
  let(:endpoint_url){api_v1_staff_emojis_path(pack_id: 11537)}
  let!(:emoji1){FactoryBot.create :emoji}
  let!(:emoji2){FactoryBot.create :emoji}

  context "get emoji icon list successfully" do
    before do
      get endpoint_url, headers: {'Authorization' => access_token}, params: {format: :json}
    end
    
    it{expect(response.status).to eq(200)}
    it{expect(JSON.parse(response.body)).to eq [emoji1, emoji2].as_json(only: %i(id package_id line_emoji_id))}
  end
end