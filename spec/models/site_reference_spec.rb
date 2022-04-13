# frozen_string_literal: true

# == Schema Information
#
# Table name: site_references
#
#  id                  :bigint           not null, primary key
#  code                :string(255)
#  line_user_id        :string(255)
#  site_measurement_id :string(255)
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#
# Indexes
#
#  index_site_references_on_code  (code)
#
require 'rails_helper'

RSpec.describe SiteReference, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
