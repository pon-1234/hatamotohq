# frozen_string_literal: true

# == Schema Information
#
# Table name: message_content_templates
#
#  id                  :bigint           not null, primary key
#  content             :text(4294967295)
#  message_type        :string(255)
#  num                 :integer          default(0)
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  message_template_id :bigint
#
# Indexes
#
#  index_message_content_templates_on_message_template_id  (message_template_id)
#
class MessageContentTemplate < ApplicationRecord
end
