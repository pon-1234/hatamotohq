# frozen_string_literal: true

module Avatarable
  extend ActiveSupport::Concern
  include Rails.application.routes.url_helpers

  included do
    has_one_attached :avatar
    validates :avatar, content_type: /\Aimage\/.*\z/
  end

  def avatar_url
    return url_for(avatar.representation(resize: '512x512')) if avatar.attached? && avatar.representable?
    nil
  end
end
