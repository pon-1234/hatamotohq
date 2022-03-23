# frozen_string_literal: true

class ScenarioSendToTesterSchedulerJob < ScenarioSchedulerJob
  def perform(channel_ids, scenario_id)
    return if channel_ids.blank?
    channel_ids.each do |channel_id|
      super(channel_id, scenario_id)
    end
  end
end
