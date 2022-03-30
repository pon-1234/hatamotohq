# frozen_string_literal: true

class Api::V1::GetMessageListValidator
  include ActiveModel::Model
  attr_accessor :channel_id, :before

  validates :channel_id, presence: true
  validate :before_valid

  private
    def before_valid
      @channel = Channel.find channel_id
      if before.present? && !@channel.messages.exists?(before)
        errors.add :before, :invalid
      end
    end
end
