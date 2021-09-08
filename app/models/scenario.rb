# frozen_string_literal: true

# == Schema Information
#
# Table name: scenarios
#
#  id                      :bigint           not null, primary key
#  after_action            :json
#  deleted_at              :datetime
#  description             :string(255)
#  mode                    :string(255)      default("date")
#  scenario_messages_count :integer
#  status                  :string(255)      default(NULL)
#  title                   :string(255)
#  type                    :string(255)      default(NULL)
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
  belongs_to :line_account
  has_many :scenario_messages, dependent: :destroy
  has_many :taggings, as: :taggable, dependent: :destroy
  has_many :tags, through: :taggings

  validates_presence_of :status
  validates :title, presence: { unless: :draft? }, length: { maximum: 255 }

  enum mode: { date: 'date', elapsed_time: 'elapsed_time' }, _prefix: true
  enum status: { enabled: 'enabled', disabled: 'disabled', draft: 'draft' }
  enum type: { auto: 'auto', manual: 'manual' }, _prefix: true

  def clone
    new_scenario = self.dup
    new_scenario.title = self.title + '（コピー）'
    new_scenario.status = :draft
    new_scenario.scenario_messages_count = nil
    new_scenario.tag_ids = self.tag_ids
    new_scenario.save!
    new_scenario
  end
end
