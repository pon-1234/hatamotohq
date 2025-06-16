# frozen_string_literal: true

# == Schema Information
#
# Table name: clients
#
#  id            :bigint           not null, primary key
#  name          :string
#  phone_number  :string
#  address       :string
#  status        :string           default("active")
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  agency_id     :bigint
#  gauth_visible :boolean          default(FALSE)
#
# Indexes
#
#  index_clients_on_agency_id  (agency_id)
#
# Foreign Keys
#
#  fk_rails_...  (agency_id => agencies.id)
#
require 'rails_helper'

RSpec.describe Client, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
