# frozen_string_literal: true

require 'rails_helper'

RSpec.shared_examples 'create common data' do
  let(:agency) { FactoryBot.create(:agency) }
  let(:client) { FactoryBot.create(:client, agency: agency) }
  let!(:admin) { FactoryBot.create(:user, client: client, is_admin: true) }
  let(:staff) { FactoryBot.create(:user, client: client, is_admin: false) }
  let(:access_token) { Common::JwtProcessor.encode({ staff_id: staff.id }) }
end
