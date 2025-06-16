# frozen_string_literal: true

# == Schema Information
#
# Table name: folders
#
#  id              :bigint           not null, primary key
#  line_account_id :bigint
#  name            :string
#  type            :string
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  deleted_at      :datetime
#
# Indexes
#
#  index_folders_on_line_account_id  (line_account_id)
#
# Foreign Keys
#
#  fk_rails_...  (line_account_id => line_accounts.id)
#
FactoryBot.define do
  factory :folder do
    name { 'sample name' }
    type { 'template_message' }
  end
end
