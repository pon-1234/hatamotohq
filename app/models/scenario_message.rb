# frozen_string_literal: true

# == Schema Information
#
# Table name: scenario_messages
#
#  id              :bigint           not null, primary key
#  scenario_id     :bigint
#  status          :string           default("disabled")
#  name            :string
#  content         :json
#  message_type_id :integer
#  date            :integer
#  time            :string
#  is_initial      :boolean          default(TRUE)
#  step            :integer
#  order           :integer
#  pause           :boolean
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  deleted_at      :datetime
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
  has_many :scenario_events, dependent: :destroy
  has_many :site_measurements, as: :measurable

  # Validation
  validates_presence_of :content, :message_type_id

  accepts_nested_attributes_for :site_measurements

  # Scope
  scope :ordered, -> { order(status: :desc, is_initial: :desc, date: :asc, time: :asc, order: :asc) }
  enum status: { enabled: 'enabled', disabled: 'disabled' }

  before_save :execute_before_save
  after_destroy do
    self.scenario.reorder_messages
  end

  def clone_to!(scenario_id)
    new_message = self.dup
    new_message.scenario_id = scenario_id
    new_message.save!
    new_message
  end

  def is_text_message?
    message_type_id == 1
  end

  private
    def execute_before_save
      self.order = 1 if order.blank? || (order == 0)
      if (date == 0) && !self.is_initial
        if self.scenario.elapsed_time_mode? && (time.to_time&.seconds_since_midnight == 0)
          self.is_initial = true
        end
      end
    rescue StandardError => e
      logger.error e.message
    end
end
