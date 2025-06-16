# frozen_string_literal: true

# == Schema Information
#
# Table name: messages
#
#  id           :bigint           not null, primary key
#  channel_id   :bigint
#  sender_type  :string
#  sender_id    :bigint
#  type         :string
#  content      :json
#  timestamp    :string
#  reply_token  :string
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  from         :string
#  text         :text
#  status       :string           default("sent")
#  html_content :text
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

FactoryBot.define do
  factory :message do
    type { 'text' }
    from { 'user' }
    text { 'sample text' }
    content { { type: 'text', text: 'sample text' } }
    timestamp { 1.hour.ago.to_s }
    status { 'sent' }
  end
end
