# frozen_string_literal: true

# == Schema Information
#
# Table name: scenarios
#
#  id                      :bigint           not null, primary key
#  action                  :json
#  deleted_at              :datetime
#  description             :string(255)
#  mode                    :string(255)      default("date")
#  scenario_messages_count :integer
#  status                  :string(255)      default("disable")
#  time_base_type          :string(255)      default("none")
#  title                   :string(255)
#  type                    :string(255)      default("normal")
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
  has_many :scenario_messages

  validates_presence_of :status
  validates :title, presence: { unless: :status_draft? }, length: { maximum: 255 }

  enum mode: { date: 'date', elapsed_time: 'elapsed_time' }, _prefix: true
  enum status: { enable: 'enable', disable: 'disable', draft: 'draft' }, _prefix: true
end
