# frozen_string_literal: true

class SendScenarioToTestersValidator
  include ActiveModel::Model

  ATTRIBUTES = %i(scenario_id line_friend_ids)
  attr_accessor(*ATTRIBUTES)

  validates :scenario_id, :line_friend_ids, presence: true
  validate :validate_scenario_id, :validate_line_friend_ids

  private
    def validate_scenario_id
      unless Scenario.exists?(scenario_id)
        errors.add :scenario_id, :invalid
      end
    end

    def validate_line_friend_ids
      unless line_friend_ids.is_a?(Array) &&
        LineFriend.by_ids(line_friend_ids).count == line_friend_ids.count
        errors.add :line_friend_ids_correct, :invalid
      end
    end
end
