# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Broadcasts::BroadcastMessageBuilderService do
  let(:agency) { create(:agency) }
  let(:client) { create(:client, agency: agency) }
  let(:line_account) { create(:line_account, client: client) }
  let(:broadcast) { create(:broadcast, line_account: line_account) }
  let(:message_type) { create(:message_type) }
  
  let(:valid_messages_params) do
    [
      {
        message_type_id: message_type.id,
        content: { type: 'text', text: 'Hello World' }
      },
      {
        message_type_id: message_type.id,
        content: { type: 'image', originalContentUrl: 'https://example.com/image.jpg' }
      }
    ]
  end
  
  let(:service) { described_class.new(broadcast, valid_messages_params) }

  describe '#build_messages' do
    context 'with valid params' do
      it 'creates broadcast messages' do
        expect {
          service.build_messages
        }.to change { broadcast.broadcast_messages.count }.by(2)
      end

      it 'returns true' do
        expect(service.build_messages).to be true
      end

      it 'removes existing messages before creating new ones' do
        # Create existing messages
        create(:broadcast_message, broadcast: broadcast)
        create(:broadcast_message, broadcast: broadcast)
        
        expect(broadcast.broadcast_messages.count).to eq(2)
        
        service.build_messages
        
        expect(broadcast.broadcast_messages.count).to eq(2)
        expect(broadcast.broadcast_messages.first.content['text']).to eq('Hello World')
      end

      context 'with site measurements' do
        let(:site) { create(:site, line_account: line_account) }
        let(:messages_with_measurements) do
          [
            {
              message_type_id: message_type.id,
              content: { type: 'text', text: 'Click here' },
              site_measurements_attributes: [
                {
                  site_id: site.id,
                  redirect_url: 'https://example.com'
                }
              ]
            }
          ]
        end
        let(:measurement_service) { described_class.new(broadcast, messages_with_measurements) }

        it 'creates site measurements' do
          expect {
            measurement_service.build_messages
          }.to change { SiteMeasurement.count }.by(1)
        end

        it 'removes id from site measurement attributes' do
          messages_with_measurements[0][:site_measurements_attributes][0][:id] = 123
          
          measurement_service.build_messages
          
          expect(SiteMeasurement.last.id).not_to eq(123)
        end
      end

      context 'with skip_shorten_url option' do
        let(:messages_with_measurements) do
          [
            {
              message_type_id: message_type.id,
              content: { type: 'text', text: 'No tracking' },
              site_measurements_attributes: [{ site_id: 1 }]
            }
          ]
        end
        let(:skip_service) { described_class.new(broadcast, messages_with_measurements, skip_shorten_url: true) }

        it 'does not create site measurements' do
          expect {
            skip_service.build_messages
          }.not_to change { SiteMeasurement.count }
        end
      end
    end

    context 'with invalid params' do
      context 'empty messages array' do
        let(:empty_service) { described_class.new(broadcast, []) }

        it 'returns false' do
          expect(empty_service.build_messages).to be false
        end

        it 'adds error' do
          empty_service.build_messages
          expect(empty_service.errors).to include('At least one message is required')
        end
      end

      context 'message with blank content' do
        let(:invalid_messages) do
          [
            {
              message_type_id: message_type.id,
              content: nil
            }
          ]
        end
        let(:invalid_service) { described_class.new(broadcast, invalid_messages) }

        it 'returns false' do
          expect(invalid_service.build_messages).to be false
        end

        it 'adds error with message index' do
          invalid_service.build_messages
          expect(invalid_service.errors).to include('Message 1 content cannot be blank')
        end
      end

      context 'when save fails' do
        before do
          allow_any_instance_of(BroadcastMessage).to receive(:save).and_return(false)
          allow_any_instance_of(BroadcastMessage).to receive(:errors).and_return(
            double(full_messages: ['Validation failed'])
          )
        end

        it 'rolls back transaction' do
          expect {
            service.build_messages
          }.not_to change { broadcast.broadcast_messages.count }
        end

        it 'returns false' do
          expect(service.build_messages).to be false
        end

        it 'adds error messages' do
          service.build_messages
          expect(service.errors).to include('Validation failed')
        end
      end
    end

    context 'when exception occurs' do
      before do
        allow(broadcast).to receive(:broadcast_messages).and_raise(StandardError, 'Database error')
      end

      it 'returns false' do
        expect(service.build_messages).to be false
      end

      it 'adds error message' do
        service.build_messages
        expect(service.errors).to include('Database error')
      end
    end
  end
end