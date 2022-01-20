# frozen_string_literal: true

class SendAvailableRoomNotificationValidator
  include ActiveModel::Model

  ATTRIBUTES = %i(uid stock_calendar type_id crm_api_key)
  AVAILABLE_ROOM_NUMBER_REGEX = /^([1-9]\d*|0)$/

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
      if available_room_number.blank?
        errors.add :base, 'ストックを入力してください'
        return
      end

      unless (available_room_number.is_a?(String) && available_room_number.match(AVAILABLE_ROOM_NUMBER_REGEX)) ||
        (available_room_number.is_a?(Integer) && available_room_number >= 0)
        errors.add :base, 'ストックが違います'
        return
      end

      errors.add :base, '空室がありません' if available_room_number.to_i == 0
    end

    def has_room_bookmark
      unless Reservation.wait.exists?(room_id: type_id, callback_url: uid)
        errors.add :base, 'ルームブックマークがありません'
      end
    end

    def available_room_number
      @available_room_number ||= stock_calendar&.first.try(:[], 'stock')
    end
end
