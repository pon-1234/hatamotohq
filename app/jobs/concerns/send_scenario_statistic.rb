# frozen_string_literal: true

module SendScenarioStatistic
  extend ActiveSupport::Concern

  def begin_sending_scenario_statistic(scenario_messages)
    line_friend = @channel.line_friend
    @scenario_log = ScenarioLog.create! scenario: @scenario, line_friend: line_friend,
      status: 'running', start_at: Time.zone.now
    @total_scenario_message_number = @scenario.after_action.try(:[], 'data') ? (scenario_messages.count + 1) : (scenario_messages.count)
    @sent_scenario_message_count = 0
    unless ReceiveScenarioFriend.exists? scenario: @scenario, line_friend: line_friend
      ReceiveScenarioFriend.create! scenario: @scenario, line_friend: line_friend, status: 'running'
      @scenario.update! sending_friend_count: @scenario.sending_friend_count.next
    end
  end

  def after_sending_scenario_statistic
    @sent_scenario_message_count += 1
    if @sent_scenario_message_count == @total_scenario_message_number
      @scenario_log.update! status: 'finished', end_at: Time.zone.now
    end
    if receive_scenario_friend = ReceiveScenarioFriend.running.find_by(scenario: @scenario, line_friend: @channel.line_friend)
      receive_scenario_friend.finished!
      @scenario.update! sending_friend_count: @scenario.sending_friend_count.pred, sent_friend_count: @scenario.sent_friend_count.next
    end
  end
end
