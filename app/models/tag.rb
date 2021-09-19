# frozen_string_literal: true

# == Schema Information
#
# Table name: tags
#
#  id              :bigint           not null, primary key
#  line_account_id :bigint
#  folder_id       :bigint
#  name            :string(255)
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
class Tag < ApplicationRecord
  belongs_to :line_account
  belongs_to :folder
  has_many :taggings, dependent: :destroy
  has_many :friends, through: :taggings, source: :taggable, source_type: 'LineFriend'
  has_many :broadcasts, through: :taggings, source: :taggable, source_type: 'Broadcast'

  validates :name, presence: true, uniqueness: { scope: :folder_id }
end
