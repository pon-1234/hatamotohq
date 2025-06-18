# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Reservations::InquiryService do
  let(:valid_params) do
    {
      friend_line_id: 'LINE123',
      num_room: 2,
      date_start: (Date.today + 1).to_s,
      date_end: (Date.today + 3).to_s
    }
  end
  let(:service) { described_class.new(valid_params) }

  describe '#process' do
    context 'with valid params' do
      it 'enqueues ReservationInquiryJob' do
        expect(ReservationInquiryJob).to receive(:perform_later).with(valid_params)
        service.process
      end

      it 'returns true' do
        allow(ReservationInquiryJob).to receive(:perform_later)
        expect(service.process).to be true
      end
    end

    context 'with invalid params' do
      context 'missing friend_line_id' do
        let(:invalid_params) { valid_params.merge(friend_line_id: '') }
        let(:invalid_service) { described_class.new(invalid_params) }

        it 'returns false' do
          expect(invalid_service.process).to be false
        end

        it 'adds error' do
          invalid_service.process
          expect(invalid_service.errors).to include('Friend LINE ID is required')
        end
      end

      context 'invalid num_room' do
        let(:invalid_params) { valid_params.merge(num_room: 0) }
        let(:invalid_service) { described_class.new(invalid_params) }

        it 'returns false' do
          expect(invalid_service.process).to be false
        end

        it 'adds error' do
          invalid_service.process
          expect(invalid_service.errors).to include('Number of rooms must be greater than 0')
        end
      end

      context 'missing dates' do
        let(:invalid_params) { valid_params.merge(date_start: '', date_end: '') }
        let(:invalid_service) { described_class.new(invalid_params) }

        it 'returns false' do
          expect(invalid_service.process).to be false
        end

        it 'adds multiple errors' do
          invalid_service.process
          expect(invalid_service.errors).to include('Start date is required')
          expect(invalid_service.errors).to include('End date is required')
        end
      end

      context 'invalid date range' do
        let(:invalid_params) do
          valid_params.merge(
            date_start: Date.today.to_s,
            date_end: Date.today.to_s
          )
        end
        let(:invalid_service) { described_class.new(invalid_params) }

        it 'returns false' do
          expect(invalid_service.process).to be false
        end

        it 'adds error' do
          invalid_service.process
          expect(invalid_service.errors).to include('End date must be after start date')
        end
      end

      context 'past start date' do
        let(:invalid_params) do
          valid_params.merge(
            date_start: (Date.today - 1).to_s,
            date_end: (Date.today + 1).to_s
          )
        end
        let(:invalid_service) { described_class.new(invalid_params) }

        it 'returns false' do
          expect(invalid_service.process).to be false
        end

        it 'adds error' do
          invalid_service.process
          expect(invalid_service.errors).to include('Start date cannot be in the past')
        end
      end

      context 'invalid date format' do
        let(:invalid_params) { valid_params.merge(date_start: 'invalid-date') }
        let(:invalid_service) { described_class.new(invalid_params) }

        it 'returns false' do
          expect(invalid_service.process).to be false
        end

        it 'adds error' do
          invalid_service.process
          expect(invalid_service.errors).to include('Invalid date format')
        end
      end
    end

    context 'when exception occurs' do
      before do
        allow(ReservationInquiryJob).to receive(:perform_later).and_raise(StandardError, 'Job error')
      end

      it 'returns false' do
        expect(service.process).to be false
      end

      it 'adds error message' do
        service.process
        expect(service.errors).to include('Job error')
      end
    end
  end
end