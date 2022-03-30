# frozen_string_literal: true

# == Schema Information
#
# Table name: scenarios
#
#  id                      :bigint           not null, primary key
#  line_account_id         :bigint
#  folder_id               :bigint
#  title                   :string(255)
#  description             :text(65535)
#  status                  :string(255)      default("disabled")
#  mode                    :string(255)      default("time")
#  type                    :string(255)      default("manual")
#  after_action            :json
#  scenario_messages_count :integer
#  created_at              :datetime         not null
#  updated_at              :datetime         not null
#  deleted_at              :datetime
#  sending_friend_count    :integer          default(0)
#  sent_friend_count       :integer          default(0)
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

FactoryBot.define do
  factory :scenario do
    title { 'sample name' }
    description { 'sample description' }
    status { 'enabled' }
    mode { 'elapsed_time' }
    type { 'manual' }
    scenario_messages_count { 1 }
  end
end
