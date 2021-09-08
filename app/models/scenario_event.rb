# frozen_string_literal: true

# == Schema Information
#
# Table name: scenario_events
#
#  id                  :bigint           not null, primary key
#  order               :integer
#  schedule_at         :datetime
#  status              :string(255)
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  channel_id          :bigint
#  line_account_id     :bigint
#  scenario_id         :bigint
#  scenario_message_id :bigint
#
# Indexes
#
#  index_scenario_events_on_channel_id           (channel_id)
#  index_scenario_events_on_line_account_id      (line_account_id)
#  index_scenario_events_on_scenario_id          (scenario_id)
#  index_scenario_events_on_scenario_message_id  (scenario_message_id)
#
# Foreign Keys
#
#  fk_rails_...  (channel_id => channels.id)
#  fk_rails_...  (line_account_id => line_accounts.id)
#  fk_rails_...  (scenario_id => scenarios.id)
#  fk_rails_...  (scenario_message_id => scenario_messages.id)
#
class ScenarioEvent < ApplicationRecord
  belongs_to :line_account
  belongs_to :scenario
  belongs_to :scenario_message
  belongs_to :channel

  enum status: { queued: 'queued', sending: 'sending', done: 'done', error: 'error' }

  # Scope
  scope :before, ->(time) { where('schedule_at <= ?', time) }
  scope :ordered, -> { order(order: :asc) }

  def deliver_now
    payload = {
      channel_id: self.channel.id,
      messages: [self.scenario_message.content]
    }
    self.update_columns(status: 'sending')
    PushMessageToLineJob.perform_now(payload)
    self.destroy
  end
end
