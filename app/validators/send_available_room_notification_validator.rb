# frozen_string_literal: true

class SendAvailableRoomNotificationValidator
  include ActiveModel::Model

  ATTRIBUTES = %i(notifier_id available_room_count type_id)

  attr_accessor(*ATTRIBUTES)

  validates :notifier_id, :type_id, presence: true
  # validates :available_room_count, numericality: { only_integer: true, greater_than: 0 }
  validate :has_room_bookmark

  private
    def has_room_bookmark
      unless Reservation.wait.exists?(room_id: type_id, notifier_id: notifier_id)
        errors.add :base, 'キャンセル待ちしている部屋が見つかりませんでした。'
      end
    end
end
