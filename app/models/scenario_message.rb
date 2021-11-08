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
#  status          :string(255)      default("disabled")
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

  # Validation
  validates_presence_of :content, :message_type_id

  # Scope
  scope :ordered, -> { order(status: :desc, is_initial: :desc, date: :asc, time: :asc, order: :asc) }
  enum status: { enabled: 'enabled', disabled: 'disabled' }

  before_save :execute_before_save

  def clone_to!(scenario_id)
    new_message = self.dup
    new_message.scenario_id = scenario_id
    new_message.save!
    new_message
  end

  private
    def execute_before_save
      self.order = 1 if order.blank? or order == 0
      if date == 0 && time.to_time&.seconds_since_midnight == 0
        self.is_initial = true
      end
    rescue StandardError => e
      logger.error e.message
    end
end
