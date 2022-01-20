# frozen_string_literal: true

class SendAvailableRoomNotificationValidator
  include ActiveModel::Model

  ATTRIBUTES = %i(uid available_room_number type_id crm_api_key)

  attr_accessor(*ATTRIBUTES)

  validates :uid, :type_id, :crm_api_key, :available_room_number, presence: true
  validates :available_room_number, numericality: { only_integer: true, greater_than: 0 }
  validate :crm_api_key_valid, :has_room_bookmark

  private
    def crm_api_key_valid
      unless crm_api_key == ENV['CRM_API_KEY']
        errors.add :crm_api_key, :invalid
      end
    end

    def has_room_bookmark
      unless Reservation.wait.exists?(room_id: type_id, callback_url: uid)
        errors.add :base, 'ルームブックマークがありません'
      end
    end
end
