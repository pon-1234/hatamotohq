# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Broadcasts::BroadcastCloneService do
  let(:agency) { create(:agency) }
  let(:client) { create(:client, agency: agency) }
  let(:line_account) { create(:line_account, client: client) }
  let(:original_broadcast) do
    create(:broadcast,
      line_account: line_account,
      title: 'Original Broadcast',
      status: 'done',
      deliver_now: true,
      schedule_at: 1.day.ago
    )
  end
  
  let(:broadcast_message) do
    create(:broadcast_message,
      broadcast: original_broadcast,
      message_type_id: 1,
      content: { type: 'text', text: 'Hello World' }
    )
  end
  
  let(:service) { described_class.new(original_broadcast) }
  
  before do
    broadcast_message
  end

  describe '#clone' do
    context 'with valid broadcast' do
      it 'creates a new broadcast' do
        expect {
          service.clone
        }.to change { Broadcast.count }.by(1)
      end

      it 'returns true' do
        expect(service.clone).to be true
      end

      it 'sets new_broadcast attribute' do
        service.clone
        expect(service.new_broadcast).to be_present
        expect(service.new_broadcast).to be_persisted
      end

      describe 'cloned broadcast attributes' do
        before { service.clone }
        let(:cloned) { service.new_broadcast }

        it 'appends (Copy) to title' do
          expect(cloned.title).to eq('Original Broadcast (Copy)')
        end

        it 'resets status to draft' do
          expect(cloned.status).to eq('draft')
        end

        it 'clears schedule_at' do
          expect(cloned.schedule_at).to be_nil
        end

        it 'sets deliver_now to false' do
          expect(cloned.deliver_now).to be false
        end


        it 'keeps the same line_account' do
          expect(cloned.line_account).to eq(line_account)
        end

        it 'copies conditions' do
          expect(cloned.conditions).to eq(original_broadcast.conditions)
        end
      end

      describe 'cloned messages' do
        before { service.clone }
        let(:cloned) { service.new_broadcast }
        let(:cloned_message) { cloned.broadcast_messages.first }

        it 'duplicates all broadcast messages' do
          expect(cloned.broadcast_messages.count).to eq(1)
        end

        it 'copies message content' do
          expect(cloned_message.content).to eq(broadcast_message.content)
        end

        it 'copies message type' do
          expect(cloned_message.message_type_id).to eq(1)
        end
      end



      context 'with multiple messages' do
        let!(:second_message) do
          create(:broadcast_message,
            broadcast: original_broadcast,
            message_type_id: 2,
            content: { type: 'image', originalContentUrl: 'https://example.com/image.jpg' }
          )
        end

        it 'duplicates all messages' do
          service.clone
          expect(service.new_broadcast.broadcast_messages.count).to eq(2)
        end
      end
    end

    context 'when broadcast save fails' do
      before do
        allow_any_instance_of(Broadcast).to receive(:save).and_return(false)
        allow_any_instance_of(Broadcast).to receive(:errors).and_return(
          double(full_messages: ['Title is invalid'])
        )
      end

      it 'returns false' do
        expect(service.clone).to be false
      end

      it 'adds error messages' do
        service.clone
        expect(service.errors).to include('Title is invalid')
      end

      it 'does not create broadcast' do
        expect {
          service.clone
        }.not_to change { Broadcast.count }
      end
    end

    context 'when message save fails' do
      before do
        allow_any_instance_of(BroadcastMessage).to receive(:save).and_return(false)
        allow_any_instance_of(BroadcastMessage).to receive(:errors).and_return(
          double(full_messages: ['Content is invalid'])
        )
      end

      it 'rolls back transaction' do
        expect {
          service.clone
        }.not_to change { Broadcast.count }
      end

      it 'returns false' do
        expect(service.clone).to be false
      end

      it 'adds error messages' do
        service.clone
        expect(service.errors).to include('Content is invalid')
      end
    end


    context 'when exception occurs' do
      before do
        allow(original_broadcast).to receive(:dup).and_raise(StandardError, 'Unexpected error')
      end

      it 'returns false' do
        expect(service.clone).to be false
      end

      it 'adds error message' do
        service.clone
        expect(service.errors).to include('Unexpected error')
      end
    end
  end
end