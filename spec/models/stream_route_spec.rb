# frozen_string_literal: true

# == Schema Information
#
# Table name: stream_routes
#
#  id                     :bigint           not null, primary key
#  folder_id              :bigint           not null
#  name                   :string
#  actions                :json
#  code                   :string
#  run_add_friend_actions :boolean          default(FALSE)
#  always_run_actions     :boolean          default(FALSE)
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  client_id              :bigint           not null
#  qr_title               :string
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
require 'rails_helper'

RSpec.describe StreamRoute, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
