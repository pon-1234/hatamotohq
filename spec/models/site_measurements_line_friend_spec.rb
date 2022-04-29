# frozen_string_literal: true

# == Schema Information
#
# Table name: site_measurements_line_friends
#
#  id                  :bigint           not null, primary key
#  site_measurement_id :bigint           not null
#  line_friend_id      :bigint           not null
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#
# Indexes
#
#  index_site_measurements_line_friends_on_line_friend_id       (line_friend_id)
#  index_site_measurements_line_friends_on_site_measurement_id  (site_measurement_id)
#
# Foreign Keys
#
#  fk_rails_...  (line_friend_id => line_friends.id)
#  fk_rails_...  (site_measurement_id => site_measurements.id)
#
require 'rails_helper'

RSpec.describe SiteMeasurementsLineFriend, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
