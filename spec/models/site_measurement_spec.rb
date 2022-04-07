# frozen_string_literal: true

# == Schema Information
#
# Table name: site_measurements
#
#  id              :bigint           not null, primary key
#  measurable_id   :integer
#  measurable_type :string(255)
#  actions         :json
#  sending_count   :integer
#  click_count     :integer
#  receiver_count  :integer
#  visitor_count   :integer
#  site_id         :bigint           not null
#  site_name       :string(255)
#  redirect_url    :text(65535)
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
