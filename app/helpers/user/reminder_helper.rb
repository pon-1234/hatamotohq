# frozen_string_literal: true

module User::ReminderHelper
  def build_reminder(params)
    reminder = Reminder.new(params)
    reminder
  end
end
