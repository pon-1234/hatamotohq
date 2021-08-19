# frozen_string_literal: true

# == Schema Information
#
# Table name: unread_messages
#
#  id              :bigint           not null, primary key
#  deleted_at      :datetime
#  total           :integer
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  channel_id      :bigint
#  last_message_id :bigint
#  line_account_id :bigint
#
# Indexes
#
#  index_unread_messages_on_channel_id       (channel_id)
#  index_unread_messages_on_last_message_id  (last_message_id)
#  index_unread_messages_on_line_account_id  (line_account_id)
#
# Foreign Keys
#
#  fk_rails_...  (channel_id => channels.id)
#  fk_rails_...  (last_message_id => messages.id)
#  fk_rails_...  (line_account_id => line_accounts.id)
#
class UnreadMessage < ApplicationRecord
end
