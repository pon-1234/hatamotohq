# frozen_string_literal: true

# == Schema Information
#
# Table name: messages
#
#  id               :bigint           not null, primary key
#  attr             :string(255)      default("chat-reserve")
#  is_bot_sender    :boolean          default(FALSE)
#  line_content     :text(4294967295)
#  line_reply_token :string(255)
#  line_timestamp   :string(255)
#  slug             :text(65535)
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  channel_id       :bigint
#  line_account_id  :bigint
#  line_message_id  :string(255)
#
# Indexes
#
#  index_messages_on_channel_id       (channel_id)
#  index_messages_on_line_account_id  (line_account_id)
#
# Foreign Keys
#
#  fk_rails_...  (channel_id => channels.id)
#  fk_rails_...  (line_account_id => line_accounts.id)
#
class Message < ApplicationRecord
end
