# frozen_string_literal: true

class StreamRouteActionHandlerJob < ApplicationJob
  queue_as :default

  def perform(friend, action)
    ActionHandlerJob.perform_now(friend, action, nil) unless friend.locked
  end
end
