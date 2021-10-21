# frozen_string_literal: true

# == Schema Information
#
# Table name: variables
#
#  id              :bigint           not null, primary key
#  line_account_id :bigint
#  folder_id       :bigint
#  name            :string(255)
#  type            :string(255)
#  default         :string(255)
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
# Indexes
#
#  index_variables_on_folder_id        (folder_id)
#  index_variables_on_line_account_id  (line_account_id)
#
# Foreign Keys
#
#  fk_rails_...  (folder_id => folders.id)
#  fk_rails_...  (line_account_id => line_accounts.id)
#
require 'rails_helper'

RSpec.describe Variable, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
