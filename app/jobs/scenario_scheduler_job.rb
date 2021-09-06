# frozen_string_literal: true

class ScenarioSchedulerJob < ApplicationJob
  queue_as :default

  def perform(channel_id, scenario_id)
    channel = Channel.find(channel_id)
    scenario = Scenario.find(scenario_id)
  end
end
