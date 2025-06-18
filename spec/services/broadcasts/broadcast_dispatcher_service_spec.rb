# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Broadcasts::BroadcastDispatcherService do
  let(:agency) { create(:agency) }
  let(:client) { create(:client, agency: agency) }
  let(:line_account) { create(:line_account, client: client) }
  let(:broadcast) { create(:broadcast, line_account: line_account, status: 'draft', deliver_now: true) }
  let(:broadcast_message) { create(:broadcast_message, broadcast: broadcast) }
  let(:service) { described_class.new(broadcast) }

  before do
    broadcast_message # Ensure message exists
    ActiveJob::Base.queue_adapter = :test
  end

  describe '#dispatch' do
    context 'with valid broadcast' do
      context 'for immediate delivery' do
        before do
          broadcast.update(deliver_now: true, status: 'pending')
        end

        it 'enqueues DispatchBroadcastJob' do
          expect {
            service.dispatch
          }.to have_enqueued_job(DispatchBroadcastJob).with(broadcast.id)
        end

        it 'updates status to sending' do
          service.dispatch
          expect(broadcast.reload.status).to eq('sending')
        end

        it 'returns true' do
          expect(service.dispatch).to be true
        end
      end

      context 'for scheduled delivery' do
        let(:schedule_time) { 1.day.from_now }
        
        before do
          broadcast.update(
            deliver_now: false,
            schedule_at: schedule_time,
            status: 'pending'
          )
        end

        it 'schedules DispatchBroadcastJob for later' do
          expect {
            service.dispatch
          }.to have_enqueued_job(DispatchBroadcastJob)
            .at(schedule_time)
            .with(broadcast.id)
        end

        it 'updates status to pending' do
          service.dispatch
          expect(broadcast.reload.status).to eq('pending')
        end

        it 'returns true' do
          expect(service.dispatch).to be true
        end
      end
    end

    context 'with invalid broadcast' do
      context 'draft broadcast' do
        before do
          broadcast.update(status: 'draft')
        end

        it 'returns false' do
          expect(service.dispatch).to be false
        end

        it 'adds error' do
          service.dispatch
          expect(service.errors).to include('Cannot dispatch draft broadcast')
        end

        it 'does not enqueue job' do
          expect {
            service.dispatch
          }.not_to have_enqueued_job(DispatchBroadcastJob)
        end
      end

      context 'already sent broadcast' do
        before do
          broadcast.update(status: 'done')
        end

        it 'returns false' do
          expect(service.dispatch).to be false
        end

        it 'adds error' do
          service.dispatch
          expect(service.errors).to include('Broadcast has already been sent')
        end
      end

      context 'currently sending broadcast' do
        before do
          broadcast.update(status: 'sending')
        end

        it 'returns false' do
          expect(service.dispatch).to be false
        end

        it 'adds error' do
          service.dispatch
          expect(service.errors).to include('Broadcast is already being sent')
        end
      end

      context 'broadcast without messages' do
        before do
          broadcast.broadcast_messages.destroy_all
          broadcast.update(status: 'pending')
        end

        it 'returns false' do
          expect(service.dispatch).to be false
        end

        it 'adds error' do
          service.dispatch
          expect(service.errors).to include('Broadcast has no messages')
        end
      end

      context 'scheduled broadcast without schedule time' do
        before do
          broadcast.update(
            deliver_now: false,
            schedule_at: nil,
            status: 'pending'
          )
        end

        it 'returns false' do
          expect(service.dispatch).to be false
        end

        it 'adds error' do
          service.dispatch
          expect(service.errors).to include('Schedule time is required for scheduled broadcasts')
        end
      end
    end

    context 'when exception occurs' do
      before do
        allow(DispatchBroadcastJob).to receive(:perform_later).and_raise(StandardError, 'Job error')
        broadcast.update(status: 'pending')
      end

      it 'returns false' do
        expect(service.dispatch).to be false
      end

      it 'adds error message' do
        service.dispatch
        expect(service.errors).to include('Job error')
      end
    end
  end
end