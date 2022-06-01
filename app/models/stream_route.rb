# frozen_string_literal: true

# == Schema Information
#
# Table name: stream_routes
#
#  id                     :bigint           not null, primary key
#  folder_id              :bigint           not null
#  name                   :string(255)
#  actions                :json
#  code                   :string(255)
#  run_add_friend_actions :boolean          default(FALSE)
#  always_run_actions     :boolean          default(FALSE)
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  client_id              :bigint           not null
#  qr_title               :string(255)
#
# Indexes
#
#  index_stream_routes_on_client_id  (client_id)
#  index_stream_routes_on_folder_id  (folder_id)
#
# Foreign Keys
#
#  fk_rails_...  (client_id => clients.id)
#  fk_rails_...  (folder_id => folders.id)
#
class StreamRoute < ApplicationRecord
  has_many :line_friends, dependent: :nullify
  belongs_to :folder
  belongs_to :client

  validates :name, :code, uniqueness: { scope: :client_id }

  before_create do
    self.code = generate_code
  end

  def generate_code
    loop do
      random_code = SecureRandom.alphanumeric(6)
      break random_code unless StreamRoute.where(client_id: client_id).exists?(code: random_code)
    end
  end

  def actions_include_scenarios?
    return false if actions.blank?
    actions_body = actions.first
    actions_body.extend Hashie::Extensions::DeepLocate
    actions_body = actions_body.deep_locate -> (key, value, object) { key.eql?('type') && value.eql?('scenario') }
    actions_body.present?
  end

  def stream_route_url
    routes = Rails.application.routes.url_helpers
    routes.stream_route_detail_with_code_url(stream_route_code: self.code)
  end
end
