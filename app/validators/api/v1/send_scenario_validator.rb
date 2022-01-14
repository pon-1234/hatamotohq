# frozen_string_literal: true

class Api::V1::SendScenarioValidator
  include ActiveModel::Model
  attr_accessor :channel_id, :scenario_id, :current_staff

  validates :channel_id, :scenario_id, presence: true
  validate :scenario_valid

  private

  def scenario_valid
    unless current_staff.line_account.scenarios.exists?(scenario_id)
      errors.add :scenario_id, :invalid
    end
  end
end
