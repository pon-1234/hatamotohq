# frozen_string_literal: true

class Api::V1::SendTemplateValidator
  include ActiveModel::Model
  attr_accessor :channel_id, :template_id, :current_staff

  validates :channel_id, :template_id, presence: true
  validate :template_valid

  private

  def template_valid
    unless current_staff.line_account.templates.exists?(template_id)
      errors.add :template_id, :invalid
    end
  end
end
