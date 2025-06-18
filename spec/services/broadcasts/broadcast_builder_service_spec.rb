# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Broadcasts::BroadcastBuilderService do
  let(:agency) { create(:agency) }
  let(:client) { create(:client, agency: agency) }
  let(:line_account) { create(:line_account, client: client) }
  let(:tag) { create(:tag, line_account: line_account) }
  
  let(:valid_params) do
    {
      title: 'Test Broadcast',
      type: 'all',
      status: 'draft',
      deliver_now: true,
      tag_ids: [tag.id]
    }
  end
  
  let(:service) { described_class.new(line_account, valid_params) }

  describe '#build' do
    context 'with valid params' do
      it 'creates a new broadcast instance' do
        broadcast = service.build
        expect(broadcast).to be_a(Broadcast)
        expect(broadcast).to be_new_record
      end

      it 'sets correct attributes' do
        broadcast = service.build
        expect(broadcast.title).to eq('Test Broadcast')
        expect(broadcast.type).to eq('all')
        expect(broadcast.status).to eq('draft')
        expect(broadcast.deliver_now).to be true
        expect(broadcast.line_account).to eq(line_account)
      end

      it 'sets conditions for all type' do
        broadcast = service.build
        expect(broadcast.conditions).to eq(Broadcast::CONDITION_SEND_ALL)
      end

      context 'with tag type' do
        let(:tag_params) do
          valid_params.merge(
            type: 'tag',
            conditions: { tag_ids: [tag.id] }
          )
        end
        let(:tag_service) { described_class.new(line_account, tag_params) }

        it 'uses provided conditions' do
          broadcast = tag_service.build
          expect(broadcast.conditions).to eq({ tag_ids: [tag.id] })
        end
      end
    end

    context 'with invalid params' do
      context 'missing title' do
        let(:invalid_params) { valid_params.merge(title: '') }
        let(:invalid_service) { described_class.new(line_account, invalid_params) }

        it 'adds error' do
          invalid_service.build
          expect(invalid_service.errors).to include('Title is required')
        end
      end

      context 'with both schedule_at and deliver_now' do
        let(:invalid_params) do
          valid_params.merge(
            deliver_now: true,
            schedule_at: 1.day.from_now
          )
        end
        let(:invalid_service) { described_class.new(line_account, invalid_params) }

        it 'adds error' do
          invalid_service.build
          expect(invalid_service.errors).to include('Cannot set both schedule_at and deliver_now')
        end
      end

      context 'with past schedule time' do
        let(:invalid_params) do
          valid_params.merge(
            deliver_now: false,
            schedule_at: 1.day.ago
          )
        end
        let(:invalid_service) { described_class.new(line_account, invalid_params) }

        it 'adds error' do
          invalid_service.build
          expect(invalid_service.errors).to include('Schedule time must be in the future')
        end
      end
    end
  end

  describe '#update' do
    let(:existing_broadcast) { create(:broadcast, line_account: line_account, title: 'Old Title') }
    let(:update_params) { valid_params.merge(title: 'Updated Title') }
    let(:update_service) { described_class.new(line_account, update_params) }

    it 'updates existing broadcast' do
      broadcast = update_service.update(existing_broadcast)
      expect(broadcast.title).to eq('Updated Title')
      expect(broadcast).to eq(existing_broadcast)
    end

    it 'validates updated broadcast' do
      invalid_params = update_params.merge(title: '')
      invalid_service = described_class.new(line_account, invalid_params)
      
      invalid_service.update(existing_broadcast)
      expect(invalid_service.errors).to include('Title is required')
    end
  end
end