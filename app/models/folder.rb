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
class Folder < ApplicationRecord
  default_scope { order(id: :asc) }
  include FolderType
  belongs_to :line_account
  has_many :tags, dependent: :destroy
  has_many :auto_responses, dependent: :destroy
  has_many :templates, dependent: :destroy
  has_many :rich_menus, dependent: :destroy
  has_many :surveys, dependent: :destroy
  has_many :reminders, dependent: :destroy
  has_many :variables, dependent: :destroy
  has_many :sites, dependent: :destroy
  has_many :stream_routes, dependent: :destroy

  # Validation
  validates :name, presence: true, uniqueness: { scope: [:line_account_id, :type] }
  validates :type, presence: true
end
