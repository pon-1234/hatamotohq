# frozen_string_literal: true

class WorkerDispatchScenarioMessage
  include Sidekiq::Worker

  def perform(*args)
    events = ScenarioEvent.queued.before(Time.zone.now + 1.minute)
    p '-------'
    p events
  end
end
