# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'GET /api/v1/staff/templates', type: :request do  
  include_examples 'check authorization'
  include_examples 'create common data' # follow data has been created: agency, client, admin, staff, access_token
  
  let(:endpoint_url){api_v1_staff_templates_path}
  let!(:line_account){FactoryBot.create(:line_account, client: client)}
  let!(:folder){line_account.folders.type_template_message.first}
  let!(:template){FactoryBot.create(:template, folder: folder, line_account: line_account)}
  let(:expectation_template_list) {[
    {
      'id' => folder.id,
      'name' => folder.name,
      'templates' => [
        template.as_json(only: [:id, :folder_id, :name, :template_messages_count])
          .merge('created_at' => template.created_at.strftime('%Y-%m-%d %H:%M'))
      ]
    }
  ]}

  context "Get template list successfully" do
    before do
      get endpoint_url, headers: {'Authorization' => access_token}, params: {format: :json}
    end
    
    it{expect(response.status).to eq(200)}
    it{expect(JSON.parse(response.body)).to eq expectation_template_list}
  end
end