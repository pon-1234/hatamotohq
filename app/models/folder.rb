# frozen_string_literal: true

# == Schema Information
#
# Table name: folders
#
#  id              :bigint           not null, primary key
#  deleted_at      :datetime
#  name            :string(255)
#  type            :string(255)
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  line_account_id :bigint
#
# Indexes
#
#  index_folders_on_line_account_id  (line_account_id)
#
# Foreign Keys
#
#  fk_rails_...  (line_account_id => line_accounts.id)
#
class Folder < ApplicationRecord
  include FolderType
  belongs_to :line_account
  has_many :tags, dependent: :destroy
end
