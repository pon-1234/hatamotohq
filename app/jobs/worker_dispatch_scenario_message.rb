# frozen_string_literal: true

class WorkerDispatchScenarioMessage
  include Sidekiq::Worker

  def perform(*args)
    events = ScenarioEvent.queued.before(Time.zone.now + 1.minute).ordered
    event.each do |event|
      deliver(event)
    end
  end

  def deliver(event)
    payload = {
      channel_id: event.channel.id,
      messages: [event.scenario_message.line_content]
    }
    PushMessageToLineJob.perform_now(payload)
  end
end
