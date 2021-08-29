# frozen_string_literal: true

# == Schema Information
#
# Table name: messages
#
#  id               :bigint           not null, primary key
#  attr             :string(255)      default("chat-reserve")
#  is_bot_sender    :boolean          default(FALSE)
#  line_content     :json
#  line_reply_token :string(255)
#  line_timestamp   :string(255)
#  sender_type      :string(255)
#  slug             :text(65535)
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  channel_id       :bigint
#  line_message_id  :string(255)
#  sender_id        :bigint
#
# Indexes
#
#  index_messages_on_channel_id                 (channel_id)
#  index_messages_on_sender_type_and_sender_id  (sender_type,sender_id)
#
# Foreign Keys
#
#  fk_rails_...  (channel_id => channels.id)
#
class Message < ApplicationRecord
  belongs_to :channel
  belongs_to :sender, polymorphic: true
end
