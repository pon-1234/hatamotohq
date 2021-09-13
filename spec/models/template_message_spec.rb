# frozen_string_literal: true

# == Schema Information
#
# Table name: template_messages
#
#  id          :bigint           not null, primary key
#  content     :json
#  order       :integer          default(0)
#  type        :string(255)
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  template_id :bigint
#
# Indexes
#
#  index_template_messages_on_template_id  (template_id)
#
# Foreign Keys
#
#  fk_rails_...  (template_id => templates.id)
#
require 'rails_helper'

RSpec.describe TemplateMessage, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
