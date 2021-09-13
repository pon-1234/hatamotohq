# frozen_string_literal: true

# == Schema Information
#
# Table name: templates
#
#  id              :bigint           not null, primary key
#  title           :string(255)
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  folder_id       :bigint
#  line_account_id :bigint
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
class Template < ApplicationRecord
  belongs_to :folder
  has_many :template_messages

  accepts_nested_attributes_for :template_messages

  enum type: { message: 'message' }, _prefix: true
end
