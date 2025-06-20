# frozen_string_literal: true

# == Schema Information
#
# Table name: tags
#
#  id              :bigint           not null, primary key
#  line_account_id :bigint
#  folder_id       :bigint
#  name            :string
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  deleted_at      :datetime
#
# Indexes
#
#  index_tags_on_folder_id        (folder_id)
#  index_tags_on_line_account_id  (line_account_id)
#
# Foreign Keys
#
#  fk_rails_...  (folder_id => folders.id)
#  fk_rails_...  (line_account_id => line_accounts.id)
#
FactoryBot.define do
  factory :tag do
    sequence(:name) { |n| "Tag #{n}" }
    line_account
    
    after(:build) do |tag|
      tag.folder ||= build(:folder, line_account: tag.line_account)
    end
  end
end
