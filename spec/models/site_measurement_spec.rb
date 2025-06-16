# frozen_string_literal: true

# == Schema Information
#
# Table name: site_measurements
#
#  id              :bigint           not null, primary key
#  measurable_id   :integer
#  measurable_type :string
#  actions         :json
#  sending_count   :integer          default(0)
#  click_count     :integer          default(0)
#  receiver_count  :integer          default(0)
#  visitor_count   :integer          default(0)
#  site_id         :bigint           not null
#  site_name       :string
#  redirect_url    :text
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
# Indexes
#
#  index_site_measurements_on_measurable_id    (measurable_id)
#  index_site_measurements_on_measurable_type  (measurable_type)
#  index_site_measurements_on_site_id          (site_id)
#
# Foreign Keys
#
#  fk_rails_...  (site_id => sites.id)
#
require 'rails_helper'

RSpec.describe SiteMeasurement, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
