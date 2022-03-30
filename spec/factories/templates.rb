# frozen_string_literal: true

# == Schema Information
#
# Table name: templates
#
#  id                      :bigint           not null, primary key
#  name                    :string(255)
#  template_messages_count :integer          default(0)
#  type                    :string(255)
#  created_at              :datetime         not null
#  updated_at              :datetime         not null
#  folder_id               :bigint
#  line_account_id         :bigint
#
# Indexes
#
#  index_templates_on_folder_id        (folder_id)
#  index_templates_on_line_account_id  (line_account_id)
#
# Foreign Keys
#
#  fk_rails_...  (folder_id => folders.id)
#  fk_rails_...  (line_account_id => line_accounts.id)
#
FactoryBot.define do
  factory :template do
    name { 'sample name' }
    template_messages_count { 1 }
    type { 'message' }
  end
end
