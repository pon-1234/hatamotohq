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
  default_scope { order(order: :asc) }

  belongs_to :template, counter_cache: true, inverse_of: :template_messages
  has_many :site_measurements, as: :measurable
  
  accepts_nested_attributes_for :site_measurements

  # Validation
  validates :message_type_id, presence: true
  validates :content, presence: true

  def clone_to!(template_id)
    new_message = self.dup
    new_message.template_id = template_id
    new_message.save!
  end
end
