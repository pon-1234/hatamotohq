# frozen_string_literal: true

class AcquireFriendJob < ApplicationJob
  sidekiq_options retry: false
  queue_as :default

  WAIT_FOR_STREAM_ROUTE_UPDATE_TIME = 5  # sleep 5s

  def perform(friend_id)
    sleep WAIT_FOR_STREAM_ROUTE_UPDATE_TIME
    @friend = LineFriend.find(friend_id)
    @stream_route = @friend.stream_route
    if !@stream_route || (@stream_route.run_add_friend_actions && !@stream_route.actions_include_scenarios?)
      apply_scenario
    end

    if @stream_route && @stream_route.actions.present?
      StreamRouteActionHandlerJob.perform_later(@friend, @stream_route.actions.first['data'])
    end
  end

  def apply_scenario
    scenarios = @friend.auto_scenarios
    scenarios.each do |scenario|
      ScenarioSchedulerJob.perform_later(@friend.channel.id, scenario.id)
    end
  end
end
