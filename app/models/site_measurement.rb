# frozen_string_literal: true

# == Schema Information
#
# Table name: site_measurements
#
#  id              :bigint           not null, primary key
#  measurable_id   :integer
#  measurable_type :string(255)
#  actions         :json
#  sending_count   :integer          default(0)
#  click_count     :integer          default(0)
#  receiver_count  :integer          default(0)
#  visitor_count   :integer          default(0)
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
class SiteMeasurement < ApplicationRecord
  belongs_to :site
  belongs_to :measurable, polymorphic: true
  has_many :site_measurements_line_friends, dependent: :destroy
end
