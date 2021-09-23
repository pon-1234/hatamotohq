# frozen_string_literal: true

# == Schema Information
#
# Table name: messages
#
#  id              :bigint           not null, primary key
#  channel_id      :bigint
#  sender_type     :string(255)
#  sender_id       :bigint
#  type            :string(255)
#  from            :string(255)
#  text            :text(65535)
#  line_message_id :string(255)
#  content         :json
#  timestamp       :string(255)
#  reply_token     :string(255)
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
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
  default_scope { order(created_at: :desc) }
  include MessageType

  enum from: { user: 'user', friend: 'friend', bot: 'bot', system: 'system' }, _prefix: true

  belongs_to :channel
  belongs_to :sender, polymorphic: true, required: false
  validates :content, presence: true
  validates :type, presence: true
  validates_presence_of :from

  before_create :exec_before_create
  after_create_commit :execute_after_create_commit

  def push_event_data
    data = {
      id: id,
      channel_id: channel_id,
      from: from,
      type: type_before_type_cast,
      created_at: created_at.to_i,
      content: content,
      timestamp: timestamp
    }
    merge_sender_attributes(data)
  end

  def merge_sender_attributes(data)
    data[:sender] = sender.push_event_data if sender && sender.is_a?(LineFriend)
    data
  end

  private
    def exec_before_create
      unless type_text?
        self.text = I18n.t("messages.sent.#{self.type}")
      end
    end

    def execute_after_create_commit
      set_conversation_activity
      dispatch_create_events
      send_reply
    end

    def set_conversation_activity
      channel.update_columns(last_activity_at: created_at, last_message: self.text)
    end

    def dispatch_create_events
      # Broadcast message via websocket
      ws_channel = "channel_user_#{channel.line_account.id}"
      Ws::ChannelWs.new(ws_channel).send_message(self)
    end

    def send_reply
      # Send reply message if sender is a friend
      return unless from.eql?('friend')
      # Enqueue auto response job
      AutoResponseJob.perform_later(id) if type.eql?('text')
    end
end
