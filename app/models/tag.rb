# frozen_string_literal: true

# == Schema Information
#
# Table name: tags
#
#  id              :bigint           not null, primary key
#  deleted_at      :datetime
#  description     :string(255)
#  name            :string(255)
#  slug            :string(255)
#  type            :string(255)      default("original")
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  folder_id       :bigint
#  line_account_id :bigint
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
class Tag < ApplicationRecord
end
