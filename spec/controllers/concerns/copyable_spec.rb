# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Copyable, type: :controller do
  controller(ApplicationController) do
    include Copyable
    
    def resource_class
      Scenario
    end
    
    def after_copy_path(resource)
      "/test/#{resource.id}"
    end
  end
  
  let(:agency) { create(:agency) }
  let(:client) { create(:client, agency: agency) }
  let(:line_account) { create(:line_account, client: client) }
  let(:scenario) { create(:scenario, line_account: line_account, name: 'Original Scenario') }
  
  before do
    routes.draw { post 'copy' => 'anonymous#copy' }
    allow(controller).to receive(:current_line_account).and_return(line_account)
  end
  
  describe '#copy' do
    context 'when copy is successful' do
      it 'creates a new resource' do
        expect {
          post :copy, params: { id: scenario.id }
        }.to change { Scenario.count }.by(1)
      end
      
      it 'adds (Copy) suffix to name' do
        post :copy, params: { id: scenario.id }
        new_scenario = Scenario.last
        expect(new_scenario.name).to eq('Original Scenario (Copy)')
      end
      
      it 'redirects to after_copy_path' do
        post :copy, params: { id: scenario.id }
        new_scenario = Scenario.last
        expect(response).to redirect_to("/test/#{new_scenario.id}")
      end
      
      it 'sets success flash message' do
        post :copy, params: { id: scenario.id }
        expect(flash[:success]).to eq(I18n.t('messages.copy_success'))
      end
    end
    
    context 'when copy fails' do
      before do
        allow_any_instance_of(Scenario).to receive(:save).and_return(false)
        allow_any_instance_of(Scenario).to receive(:errors).and_return(
          double(full_messages: ['Validation failed'])
        )
      end
      
      it 'does not create a new resource' do
        expect {
          post :copy, params: { id: scenario.id }
        }.not_to change { Scenario.count }
      end
      
      it 'sets error flash message' do
        post :copy, params: { id: scenario.id }
        expect(flash[:error]).to eq('Validation failed')
      end
    end
    
    context 'when exception occurs' do
      before do
        allow(Scenario).to receive(:find).and_raise(StandardError, 'Something went wrong')
      end
      
      it 'logs the error' do
        expect(Rails.logger).to receive(:error).with(/Copy failed/)
        post :copy, params: { id: scenario.id }
      end
      
      it 'sets error flash message' do
        post :copy, params: { id: scenario.id }
        expect(flash[:error]).to eq(I18n.t('errors.copy_failed'))
      end
    end
  end
end