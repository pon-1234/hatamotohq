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
class Template < ApplicationRecord
  # Association
  belongs_to :line_account
  belongs_to :folder
  has_many :template_messages, inverse_of: :template, dependent: :destroy

  accepts_nested_attributes_for :template_messages, allow_destroy: true
  # Validation
  validates :name, presence: true, length: { maximum: 255 }

  # Scope
  enum type: { message: 'message' }, _prefix: true

  def clone
    new_template = self.dup
    new_template.name = self.name + '（コピー）'
    new_template.template_messages_count = 0
    new_template.save!
    self.template_messages.each { |message| message.clone_to(new_template.id) }
    new_template
  end
end
