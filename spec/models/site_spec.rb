# frozen_string_literal: true

# == Schema Information
#
# Table name: sites
#
#  id                  :bigint           not null, primary key
#  url                 :text(65535)
#  name                :string(255)
#  folder_id           :bigint           not null
#  sending_count       :integer
#  click_count_integer :string(255)
#  receiver_count      :integer
#  visitor_count       :integer
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  client_id           :bigint           not null
#
# Indexes
#
#  index_sites_on_client_id  (client_id)
#  index_sites_on_folder_id  (folder_id)
#
# Foreign Keys
#
#  fk_rails_...  (client_id => clients.id)
#  fk_rails_...  (folder_id => folders.id)
#
require 'rails_helper'

RSpec.describe Site, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
