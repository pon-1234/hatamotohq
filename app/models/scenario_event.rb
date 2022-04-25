# frozen_string_literal: true

# == Schema Information
#
# Table name: scenario_events
#
#  id                  :bigint           not null, primary key
#  line_account_id     :bigint
#  scenario_id         :bigint
#  scenario_message_id :bigint
#  type                :string(255)
#  content             :json
#  channel_id          :bigint
#  schedule_at         :datetime
#  order               :integer
#  status              :string(255)
#  is_last             :boolean          default(FALSE)
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  scenario_log_id     :bigint
#
# Indexes
#
#  index_scenario_events_on_channel_id           (channel_id)
#  index_scenario_events_on_line_account_id      (line_account_id)
#  index_scenario_events_on_scenario_id          (scenario_id)
#  index_scenario_events_on_scenario_log_id      (scenario_log_id)
#  index_scenario_events_on_scenario_message_id  (scenario_message_id)
#
# Foreign Keys
#
#  fk_rails_...  (channel_id => channels.id)
#  fk_rails_...  (line_account_id => line_accounts.id)
#  fk_rails_...  (scenario_id => scenarios.id)
#  fk_rails_...  (scenario_log_id => scenario_logs.id)
#  fk_rails_...  (scenario_message_id => scenario_messages.id)
#
class ScenarioEvent < ApplicationRecord
  include User::MessagesHelper
  include SendScenarioStatistic

  belongs_to :line_account
  belongs_to :scenario
  belongs_to :scenario_message, optional: true # root message can be deleted
  belongs_to :channel
  belongs_to :scenario_log, optional: true

  # Scope
  enum status: { queued: 'queued', sending: 'sending', done: 'done', error: 'error' }
  enum type: { message: 'message', after_action: 'after_action' }, _prefix: true
  scope :before, ->(time) { where('schedule_at <= ?', time) }
  scope :ordered, -> { order(order: :asc) }

  def deliver_now
    case self.type
    when 'message'
      deliver_message
    when 'after_action'
      deliver_after_action
    end
    execute_after_deliver
  end

  private
    def deliver_message
      normalized = self.content
      if contain_survey_action?(normalized)
        normalized = normalize_messages_with_survey_action(self.channel, normalized)
      end
      payload = {
        channel_id: self.channel.id,
        messages: [normalized]
      }
      self.update_columns(status: 'sending')
      PushMessageToLineJob.perform_now(payload)
    end

    def deliver_after_action
      ActionHandlerJob.perform_now(self.channel.line_friend, self.content)
    end

    def execute_after_deliver
      update_site_measurement_statistic([scenario_message], [self.channel.line_friend]) if scenario_message
      # If this event is the last
      if self.is_last
        Messages::SystemLogBuilder.new(self.channel).perform_scenario_end(self.scenario)
        scenario_log.update(status: 'done', end_at: Time.zone.now) if scenario_log
        update_scenario_statistics(scenario, channel.line_friend)
      end
      self.destroy
    end
end
