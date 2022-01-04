# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'DELETE /api/v1/staff/logout', type: :request do
  let(:endpoint_url){'/api/v1/staff/logout'}
  let(:agency){FactoryBot.create(:agency)}
  let(:client){FactoryBot.create(:client, agency: agency)}
  let(:user){FactoryBot.create(:user, client: client, is_admin: false)}
  let(:access_token){Common::JwtProcessor.encode({staff_id: user.id})}

  include_examples 'check authorization'

  context 'Logout successfully' do
    before do
      delete endpoint_url, headers: {"Authorization" => access_token}
    end

    it{expect(response.status).to eq(200)}
    it{expect(JSON.parse(response.body)['status']).to eq 'success'}
  end
end
