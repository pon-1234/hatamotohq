# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Reservations::PrecheckinService do
  let(:agency) { create(:agency) }
  let(:client) { create(:client, agency: agency) }
  let(:line_account) { create(:line_account, client: client, pms_api_key: 'test_api_key') }
  let(:line_friend) { create(:line_friend, line_account: line_account) }
  let(:params) do
    {
      phone_number: '090-1234-5678',
      check_in_date: '2024-01-01',
      name: 'Test User',
      birthday: '1990-01-01',
      gender: 'male',
      companion: 2
    }
  end
  let(:service) { described_class.new(line_friend, params) }

  describe '#find_or_fetch_precheckin_data' do
    context 'when existing precheckin exists' do
      let!(:existing_precheckin) do
        create(:reservation_precheckin,
          line_friend: line_friend,
          line_account: line_account,
          phone_number: params[:phone_number],
          check_in_date: params[:check_in_date],
          name: 'Existing User'
        )
      end

      it 'returns existing precheckin data' do
        result = service.find_or_fetch_precheckin_data
        expect(result[:name]).to eq('Existing User')
        expect(result[:phone_number]).to eq(params[:phone_number])
      end
    end

    context 'when no existing precheckin' do
      let(:reservation_response) do
        [{
          'id' => 'RES123',
          'guestId' => 'GUEST123',
          'companion' => 3
        }]
      end

      let(:guest_response) do
        {
          'name' => 'PMS User',
          'address' => 'Tokyo',
          'birthday' => '1985-05-05',
          'gender' => 'female'
        }
      end

      before do
        allow_any_instance_of(Pms::Reservation::SearchReservations)
          .to receive(:perform).and_return(reservation_response)
        allow_any_instance_of(Pms::Guest::GetGuests)
          .to receive(:perform).and_return(guest_response)
      end

      it 'fetches data from PMS' do
        result = service.find_or_fetch_precheckin_data
        expect(result[:name]).to eq('PMS User')
        expect(result[:address]).to eq('Tokyo')
        expect(result[:companion]).to eq(3)
      end
    end

    context 'when PMS returns no data' do
      before do
        allow_any_instance_of(Pms::Reservation::SearchReservations)
          .to receive(:perform).and_return(nil)
      end

      it 'returns basic data only' do
        result = service.find_or_fetch_precheckin_data
        expect(result[:phone_number]).to eq(params[:phone_number])
        expect(result[:check_in_date]).to eq(params[:check_in_date])
        expect(result[:name]).to be_nil
      end
    end
  end

  describe '#create_or_update_precheckin' do
    context 'with valid params' do
      context 'when creating new precheckin' do
        it 'creates a new precheckin record' do
          expect {
            service.create_or_update_precheckin
          }.to change { ReservationPrecheckin.count }.by(1)
        end

        it 'returns true' do
          expect(service.create_or_update_precheckin).to be true
        end

        it 'sets correct success message' do
          service.create_or_update_precheckin
          expect(service.success_message).to eq(I18n.t('messages.precheckin.create_success'))
        end
      end

      context 'when updating existing precheckin' do
        let!(:existing_precheckin) do
          create(:reservation_precheckin,
            line_friend: line_friend,
            line_account: line_account,
            phone_number: params[:phone_number],
            check_in_date: params[:check_in_date],
            name: 'Old Name'
          )
        end

        it 'updates the existing record' do
          service.create_or_update_precheckin
          existing_precheckin.reload
          expect(existing_precheckin.name).to eq('Test User')
        end

        it 'does not create new record' do
          expect {
            service.create_or_update_precheckin
          }.not_to change { ReservationPrecheckin.count }
        end

        it 'sets correct success message' do
          service.create_or_update_precheckin
          expect(service.success_message).to eq(I18n.t('messages.precheckin.update_success'))
        end
      end

      context 'when PMS update is needed' do
        let(:reservation_response) do
          [{
            'id' => 'RES123',
            'guestId' => 'GUEST123'
          }]
        end

        before do
          allow_any_instance_of(Pms::Reservation::SearchReservations)
            .to receive(:perform).and_return(reservation_response)
          allow_any_instance_of(Pms::Guest::UpdateGuest)
            .to receive(:perform).and_return(true)
          allow_any_instance_of(Pms::Reservation::UpdateReservations)
            .to receive(:perform).and_return(true)
        end

        it 'updates guest information in PMS' do
          expect_any_instance_of(Pms::Guest::UpdateGuest)
            .to receive(:perform).with('GUEST123', hash_including(:birthday, :gender))
          
          service.create_or_update_precheckin
        end

        it 'updates reservation information in PMS' do
          expect_any_instance_of(Pms::Reservation::UpdateReservations)
            .to receive(:perform).with('RES123', { companion: 2 })
          
          service.create_or_update_precheckin
        end
      end
    end

    context 'with invalid params' do
      let(:invalid_params) { { name: 'Test' } }
      let(:invalid_service) { described_class.new(line_friend, invalid_params) }

      it 'returns false' do
        expect(invalid_service.create_or_update_precheckin).to be false
      end

      it 'adds errors' do
        invalid_service.create_or_update_precheckin
        expect(invalid_service.errors).to include('Phone number is required')
        expect(invalid_service.errors).to include('Check-in date is required')
      end
    end

    context 'when exception occurs' do
      before do
        allow(ReservationPrecheckin).to receive(:create!).and_raise(StandardError, 'Database error')
      end

      it 'returns false' do
        expect(service.create_or_update_precheckin).to be false
      end

      it 'adds error message' do
        service.create_or_update_precheckin
        expect(service.errors).to include('Database error')
      end
    end
  end
end