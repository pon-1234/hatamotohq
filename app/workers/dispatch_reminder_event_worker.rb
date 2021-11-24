# frozen_string_literal: true

class DispatchReminderEventWorker
  include Sidekiq::Worker

  def perform(*args)
    events = ReminderEvent.queued.before(Time.zone.now + 1.minute)
    events.each do |event|
      event.invoke
    end
  end
end
