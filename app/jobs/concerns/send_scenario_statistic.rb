# frozen_string_literal: true

module SendScenarioStatistic
  extend ActiveSupport::Concern

  def begin_sending_scenario_statistic(scenario_messages)
    line_friend = @channel.line_friend
    @scenario_log = ScenarioLog.create! scenario: @scenario, line_friend: line_friend,
      status: 'running', start_at: Time.zone.now
    @total_scenario_message_number = @scenario.after_action.try(:[], 'data') ? (scenario_messages.count + 1) : (scenario_messages.count)
    @sent_scenario_message_count = 0
    if !ScenarioFriend.exists?(scenario: @scenario, line_friend: line_friend) || ScenarioFriend.done.exists?(scenario: @scenario,
      line_friend: line_friend)
      ScenarioFriend.create! scenario: @scenario, line_friend: line_friend, status: 'running'
      @scenario.update! sending_friend_count: @scenario.sending_friend_count.next
    end
  end

  def after_sending_scenario_statistic
    @sent_scenario_message_count += 1
    if @sent_scenario_message_count == @total_scenario_message_number
      @scenario_log.update! status: 'done', end_at: Time.zone.now
    end
    update_scenario_statistics(@scenario, @channel.line_friend)
  end

  def update_scenario_statistics(scenario, line_friend)
    scenario_friend = ScenarioFriend.running.find_by(scenario: scenario, line_friend: line_friend)
    return unless scenario_friend
    if ScenarioFriend.done.exists?(scenario: scenario, line_friend: line_friend)
      scenario_friend.destroy
      scenario.update! sending_friend_count: scenario.sending_friend_count.pred
    else
      scenario_friend.done!
      scenario.update! sending_friend_count: scenario.sending_friend_count.pred, sent_friend_count: scenario.sent_friend_count.next
    end
  end
end
