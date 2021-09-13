# frozen_string_literal: true

# == Schema Information
#
# Table name: template_messages
#
#  id              :bigint           not null, primary key
#  content         :json
#  order           :integer          default(0)
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  message_type_id :integer
#  template_id     :bigint
#
# Indexes
#
#  index_template_messages_on_template_id  (template_id)
#
# Foreign Keys
#
#  fk_rails_...  (template_id => templates.id)
#
class TemplateMessage < ApplicationRecord
  belongs_to :template, inverse_of: :template_messages

  # Validation
  validates :message_type_id, presence: true
  validates :content, presence: true
end
