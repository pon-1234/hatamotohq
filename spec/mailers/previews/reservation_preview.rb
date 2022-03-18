# frozen_string_literal: true

# Preview all emails at http://localhost:3000/rails/mailers/reservation
class ReservationPreview < ActionMailer::Preview
  # Preview this email at http://localhost:3000/rails/mailers/reservation/contact_to_client
  def contact_to_client
    latest_pms_reservation_hash = {
      'agencyBookingNumber' => 'test123',
      'agencyCode' => '12',
      'agencyName' => 'test Agency',
      'agencyPlanCode' => '123',
      'agencyPlanName' => 'テストプラン',
      'bookingDate' => '2022-01-22',
      'bookingTime' => '12:23:34',
      'chargeClaimed' => 12345,
      'chargeTotal' => 12345,
      'chargeType' => 'RoomRate',
      'checkInDate' => '2022-01-21',
      'checkInTime' => '12:30:00',
      'checkOutDate' => '2022-01-23',
      'guestName' => '山田',
      'guestKana' => 'ヤマダ',
      'guestPhoneNumber' => '0123459799',
      'pms_id' => 'R100000',
      'insightMemo' => 'あああああ',
      'nights' => 1,
      'orderMemo' => "コメント\nあいうえお",
      'payment' => 'Credit',
      'propId' => 'P100001',
      'roomList' => [
        {
          'agencyRoomTypeCode' => 'test',
          'agencyRoomTypeName' => 'test',
          'paxCount' => 12,
          'roomId' => 101,
          'roomName' => '123 11',
          'roomTypeId' => 100,
          'roomTypeName' => 'test',
          'stayStatus' => 'Departing'
        }
      ]
    }
    latest_pms_reservation_hash = latest_pms_reservation_hash.deep_transform_keys { |key| key.to_s.underscore }

    latest_pms_reservation = LatestPmsReservation.new latest_pms_reservation_hash

    ReservationMailer.contact_to_client LineFriend.first, latest_pms_reservation
  end
end
