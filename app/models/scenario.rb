# frozen_string_literal: true

# == Schema Information
#
# Table name: scenarios
#
#  id                      :bigint           not null, primary key
#  after_action            :json
#  deleted_at              :datetime
#  description             :string(255)
#  mode                    :string(255)      default("time")
#  scenario_messages_count :integer
#  status                  :string(255)      default("disabled")
#  title                   :string(255)
#  type                    :string(255)      default("manual")
#  created_at              :datetime         not null
#  updated_at              :datetime         not null
#  folder_id               :bigint
#  line_account_id         :bigint
#
# Indexes
#
#  index_scenarios_on_folder_id        (folder_id)
#  index_scenarios_on_line_account_id  (line_account_id)
#
# Foreign Keys
#
#  fk_rails_...  (folder_id => folders.id)
#  fk_rails_...  (line_account_id => line_accounts.id)
#
class Scenario < ApplicationRecord
  default_scope { order(created_at: :desc) }
  belongs_to :line_account
  has_many :scenario_events, dependent: :destroy
  has_many :scenario_messages, dependent: :destroy
  has_many :taggings, as: :taggable, dependent: :destroy
  has_many :tags, through: :taggings

  validates_presence_of :status
  validates :title, presence: { unless: :draft? }, length: { maximum: 255 }

  enum mode: { time: 'time', elapsed_time: 'elapsed_time' }, _suffix: true
  enum status: { enabled: 'enabled', disabled: 'disabled', draft: 'draft' }
  enum type: { auto: 'auto', manual: 'manual' }

  # Scope
  scope :not_empty, -> { where('scenario_messages_count > 0') }

  def clone!
    new_scenario = self.dup
    new_scenario.title = self.title + '（コピー）'
    new_scenario.status = :draft
    new_scenario.scenario_messages_count = nil
    new_scenario.tag_ids = self.tag_ids
    new_scenario.save!
    self.scenario_messages&.each { |message| message.clone_to!(new_scenario.id) }
    new_scenario
  end

  def reorder_messages
    orderd_messages = scenario_messages.ordered
    orderd_messages.each_with_index do |message, index|
      message.step = index + 1
      message.save
    end
  end
end
