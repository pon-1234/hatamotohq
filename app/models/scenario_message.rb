# frozen_string_literal: true

# == Schema Information
#
# Table name: scenario_messages
#
#  id               :bigint           not null, primary key
#  content          :text(4294967295)
#  deleted_at       :datetime
#  delivery_timing  :string(255)
#  message_type     :string(255)
#  name             :string(255)
#  priority         :float(24)        default(999.0)
#  status           :string(255)      default("disable")
#  time_designation :string(255)      default("00:00")
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  scenario_id      :bigint
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
end
