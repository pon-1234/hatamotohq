# frozen_string_literal: true

# == Schema Information
#
# Table name: scenarios
#
#  id                   :bigint           not null, primary key
#  action               :text(4294967295)
#  content              :string(255)
#  deleted_at           :datetime
#  delivery_timing_type :string(255)      default("now")
#  status               :string(255)      default("disable")
#  time_base_type       :string(255)      default("none")
#  title                :string(255)
#  type                 :string(255)      default("normal")
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#  folder_id            :bigint
#  line_account_id      :bigint
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
end
