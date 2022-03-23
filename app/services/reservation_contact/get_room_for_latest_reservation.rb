# frozen_string_literal: true

class ReservationContact::GetRoomForLatestReservation
  def perform(latest_reservation)
    prepared_params = {
      dateStart: latest_reservation.check_in_date,
      dateEnd: latest_reservation.check_out_date
    }
    rooms = Pms::GetRoom.new.perform(prepared_params)
    if rooms.present?
      correct_room = rooms.select { |room| room['typeId'] == latest_reservation.room_list.first['room_id'] }.first
      {
        room_photo_url: correct_room['roomPhotos']&.first,
        room_area: "#{correct_room['roomArea']['value']}#{correct_room['roomArea']['unit']}",
        not_smock: correct_room['nonSmoking']
      }
    end
  end
end
