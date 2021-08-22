# == Schema Information
#
# Table name: broadcast_messages
#
#  id           :bigint           not null, primary key
#  content      :text(4294967295)
#  deleted_at   :datetime
#  message_type :string(255)
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  broadcast_id :bigint
#
# Indexes
#
#  index_broadcast_messages_on_broadcast_id  (broadcast_id)
#
# Foreign Keys
#
#  fk_rails_...  (broadcast_id => broadcasts.id)
#
require 'rails_helper'

RSpec.describe BroadcastMessage, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
