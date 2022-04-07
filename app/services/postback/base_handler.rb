# frozen_string_literal: true

class Postback::BaseHandler
  def initialize(friend, content, reply_token = nil)
    @friend = friend
    @content = content
  end

  def send_text_message(text)
    message = Messages::MessageBuilder.new(nil, @friend.channel, { message: { type: 'text', text: text } }.try(:with_indifferent_access)).perform
    LineApi::PushMessage.new(@friend.line_account).perform([message.content], @friend.line_user_id)
  end
end
