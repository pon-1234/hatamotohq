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
FactoryBot.define do
  factory :site_measurement do
    measurable_id { 1 }
    measurable_type { 'MyString' }
    actions { '' }
    sending_count { 1 }
    click_count { 1 }
    receiver_count { 1 }
    visitor_count { 1 }
    site { nil }
    site_name { 'MyString' }
    redirect_url { 'MyText' }
  end
end
