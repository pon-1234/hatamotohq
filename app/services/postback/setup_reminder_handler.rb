# frozen_string_literal: true

class Postback::SetupReminderHandler < Postback::BaseHandler
  def perform
    type = @content['type']
    set_reminder(@content) if type == 'set'
    unset_reminder(@content) if type == 'unset'
  end

  def set_reminder(content)
    goal = @content['goal']
    reminder_id = @content['reminder']['id']
    reminder = Reminder.find(reminder_id)
    # Cancel all active reminding
    active_remindings = reminder.remindings.where("remindings.channel_id = ? AND remindings.status = 'active'", @friend.channel.id)
    active_remindings.includes([:channel, :reminder_events]).each { |_| _.cancel }
    # Start a new reminding
    reminding = Reminding.new(channel: @friend.channel, reminder: reminder, goal: goal, status: 'active')
    reminding.save!
  end

  def unset_reminder(content)
    reminder_id = @content['reminder']['id']
    reminder = Reminder.find(reminder_id)
    remindings = reminder.remindings.where('remindings.channel_id = ?', @friend.channel.id)
    remindings.each do |reminding|
      reminding.cancel
    end
  end
end
