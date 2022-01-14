# frozen_string_literal: true

class Api::V1::SendMessageValidator
  include ActiveModel::Model

  ATTRIBUTES = %i(type packageId stickerId originalContentUrl previewImageUrl duration text)
  attr_accessor *[*ATTRIBUTES, :current_staff] # trick: add an element to array

  validates :type, presence: true, inclusion: { in: Message.types.keys }

  with_options if: -> { type == 'sticker' } do |message|
    message.validates :packageId, :stickerId, presence: true
    message.validate :package_valid, :sticker_valid
  end

  with_options if: -> { type == 'text' } do |message|
    message.validates :text, presence: true
  end

  with_options if: -> { type.in?(%w(image audio video richmenu)) } do |message|
    message.validates :originalContentUrl, presence: true
    message.validates :duration, presence: true, if: -> { type == 'audio' }
    message.validate :originalContentUrl_valid, :previewImageUrl_valid
  end

  private

  def package_valid
    unless Emoji.exists?(package_id: packageId)
      errors.add :packageId, :invalid
    end
  end

  def sticker_valid
    unless Emoji.exists?(package_id: packageId, line_emoji_id: stickerId)
      errors.add :stickerId, :invalid
    end
  end

  def originalContentUrl_valid
    unless current_staff.line_account.medias.map(&:url).include?(originalContentUrl)
      errors.add :originalContentUrl, :invalid
    end
  end

  def previewImageUrl_valid
    if previewImageUrl.present? && current_staff.line_account.medias.map(&:preview_url).exclude?(previewImageUrl)
      errors.add :previewImageUrl, :invalid
    end
  end
end
