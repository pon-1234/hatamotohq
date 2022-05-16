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
  # trick: create this relationship to use polymorphic in where, order clause
  belongs_to :scenario_message, -> { where(site_measurements: { measurable_type: 'ScenarioMessage' }) },
    foreign_key: 'measurable_id', optional: true
  belongs_to :broadcast_message, -> { where(site_measurements: { measurable_type: 'BroadcastMessage' }) },
    foreign_key: 'measurable_id', optional: true
  has_many :site_measurements_line_friends, dependent: :destroy

  scope :scenario_messages_of_site, -> do
    where(measurable_type: 'ScenarioMessage').includes(scenario_message: :scenario)
      .order('scenarios.id, scenario_messages.order')
  end

  scope :broadcast_messages_of_site, -> do
    where(measurable_type: 'BroadcastMessage').includes(broadcast_message: { broadcast: :tags })
      .order('broadcasts.id')
  end

  before_save :set_default_site_name

  def real_site_url
    redirect_url || site.url
  end

  def real_site_name
    site_name || site.name
  end

  private
    def set_default_site_name
      self.site_name = site.name unless self.site_name.present?
    end
end
