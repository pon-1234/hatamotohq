# frozen_string_literal: true

# == Schema Information
#
# Table name: episodes
#
#  id          :bigint           not null, primary key
#  reminder_id :bigint
#  is_initial  :boolean
#  date        :integer
#  time        :string
#  actions     :json
#  messages    :json
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
# Indexes
#
#  index_episodes_on_reminder_id  (reminder_id)
#
# Foreign Keys
#
#  fk_rails_...  (reminder_id => reminders.id)
#
require 'rails_helper'

RSpec.describe Episode, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
