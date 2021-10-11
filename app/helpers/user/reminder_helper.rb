# frozen_string_literal: true

module User::ReminderHelper
  def build_reminder(params)
    reminder = Reminder.new(params)
    reminder.line_account = Current.user.line_account
    reminder
  end
end
