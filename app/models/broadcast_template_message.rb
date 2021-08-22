# == Schema Information
#
# Table name: broadcast_template_messages
#
#  id                    :bigint           not null, primary key
#  content               :text(4294967295)
#  message_type          :string(255)
#  sort_order            :integer          default(0)
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#  broadcast_template_id :bigint
#
# Indexes
#
#  index_broadcast_template_messages_on_broadcast_template_id  (broadcast_template_id)
#
# Foreign Keys
#
#  fk_rails_...  (broadcast_template_id => broadcast_templates.id)
#
class BroadcastTemplateMessage < ApplicationRecord
end
