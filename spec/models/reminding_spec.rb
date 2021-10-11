# frozen_string_literal: true

# == Schema Information
#
# Table name: remindings
#
#  id          :bigint           not null, primary key
#  channel_id  :bigint
#  reminder_id :bigint
#  goal        :datetime
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
# Indexes
#
#  index_remindings_on_channel_id   (channel_id)
#  index_remindings_on_reminder_id  (reminder_id)
#
# Foreign Keys
#
#  fk_rails_...  (channel_id => channels.id)
#  fk_rails_...  (reminder_id => reminders.id)
#
require 'rails_helper'

RSpec.describe Reminding, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
