# frozen_string_literal: true

class DispatchScenarioEventWorker
  include Sidekiq::Worker

  def perform(*args)
    events = ScenarioEvent.queued.before(Time.zone.now).ordered
    events.each do |event|
      event.deliver_now
    end
  end
end
