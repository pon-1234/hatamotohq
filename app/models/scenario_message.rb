# frozen_string_literal: true

# == Schema Information
#
# Table name: scenario_messages
#
#  id              :bigint           not null, primary key
#  content         :json
#  date            :integer
#  deleted_at      :datetime
#  is_initial      :boolean          default(TRUE)
#  name            :string(255)
#  order           :integer
#  pause           :boolean
#  status          :string(255)      default("disable")
#  step            :integer
#  time            :string(255)
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  message_type_id :integer
#  scenario_id     :bigint
#
# Indexes
#
#  index_scenario_messages_on_scenario_id  (scenario_id)
#
# Foreign Keys
#
#  fk_rails_...  (scenario_id => scenarios.id)
#
class ScenarioMessage < ApplicationRecord
  belongs_to :scenario, counter_cache: true

  validates_presence_of :content, :message_type_id

  # Scope
  scope :ordered, -> { order(is_initial: :desc, date: :asc, time: :asc, order: :asc) }

  def clone_to(scenario_id)
    new_message = self.dup
    new_message.scenario_id = scenario_id
    new_message.save!
    new_message
  end
end
