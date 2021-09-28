# frozen_string_literal: true

class AcquireFriendJob < ApplicationJob
  sidekiq_options retry: false
  queue_as :default

  def perform(friend_id)
    @friend = LineFriend.find(friend_id)
    apply_scenario
  end

  def apply_scenario
    scenarios = @friend.auto_scenarios
    scenarios.each do |scenario|
      ScenarioSchedulerJob.perform_later(@friend.channel.id, scenario.id)
    end
  end
end
