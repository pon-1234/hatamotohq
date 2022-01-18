# frozen_string_literal: true

class SendAvailableRoomNotificationValidator
  include ActiveModel::Model

  ATTRIBUTES = %i(uid stock_calendar type_id crm_api_key)
  attr_accessor(*ATTRIBUTES)

  validates :uid, :type_id, :crm_api_key, presence: true
  validate :crm_api_key_valid, :has_available_room, :has_room_bookmark

  private
    def crm_api_key_valid
      unless crm_api_key == ENV['CRM_API_KEY']
        errors.add :crm_api_key, :invalid
      end
    end

    def has_available_room
      if stock_calendar&.first.try(:[], 'stock').to_i == 0
        errors.add :base, '空室がありません'
      end
    end

    def has_room_bookmark
      unless Reservation.wait.exists?(room_id: type_id, callback_url: uid)
        errors.add :base, 'ルームブックマークがありません'
      end
    end
end
