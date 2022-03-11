# frozen_string_literal: true

# Preview all emails at http://localhost:3000/rails/mailers/reservation
class ReservationPreview < ActionMailer::Preview
  # Preview this email at http://localhost:3000/rails/mailers/reservation/contact_to_client
  def contact_to_client
    sample_from_pms_client = {
      "address" => "東京都中央区1-1-1",
      "create_time" => "2022-01-12T04:34:03.990000+00:00",
      "email" => "update@example.com",
      "id" => "G100000",
      "line_id" => "U120a7ed4b513589c29bf5f01375e5441",
      "name" => "山田太郎",
      "name_kana" => "ヤマダ　タロウ",
      "latest_reservation" => {
        "agencyBookingNumber" => "test123",
        "agencyCode" => "12",
        "agencyName" => "test Agency",
        "agencyPlanCode" => "123",
        "agencyPlanName" => "テストプラン",
        "bookingDate" => "2022-01-22",
        "bookingTime" => "12:23:34",
        "chargeClaimed" => 12345,
        "chargeTotal" => 12345,
        "chargeType" => "RoomRate",
        "checkInDate" => "2022-01-21",
        "checkInTime" => "12:30:00",
        "checkOutDate" => "2022-01-23",
        "guestName" => "山田",
        "guestKana" => "ヤマダ",
        "id" => "R100000",
        "insightMemo" => "あああああ",
        "nights" => 1,
        "orderMemo" => "コメント\nあいうえお",
        "payment" => "Credit",
        "propId" => "P100001",
        "roomList" => [
          {
            "agencyRoomTypeCode" => "test",
            "agencyRoomTypeName" => "test",
            "paxCount" => 12,
            "roomId" => 101,
            "roomName" => "123 11",
            "roomTypeId" => 100,
            "roomTypeName" => "test",
            "stayStatus" => "Departing"
          }
        ]
      },
      "phone_number_primary" => "08066778899",
      "phone_number_secondary" => "09012345678",
      "postcode" => "1231234"
    }

    ReservationMailer.contact_to_client LineFriend.first, sample_from_pms_client
  end
end
