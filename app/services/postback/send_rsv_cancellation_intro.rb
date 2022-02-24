# frozen_string_literal: true

class Postback::SendRsvCancellationIntro < Postback::BaseHandler
  def perform
    # Send messages to confirm cancellation
    reservations = @friend.reservations.wait
    reservations.each do |reservation|
      msg_content = {
        type: 'template',
        altText: '空室待ちキャンセルの確認',
        template: {
          type: 'confirm',
          text: "本当に空室待ちをキャンセルしてもよろしいですか？空室名：#{reservation.room_name}",
          actions: [
            {
              type: 'postback',
              label: 'いいえ',
              displayText: 'いいえ',
              data: {
                actions: [
                  { type: 'none' }
                ]
              }
            },
            {
              type: 'postback',
              label: 'はい',
              displayText: 'はい',
              data: {
                actions: [
                  { type: 'rsv_rm_bookmark', content: { reservation_id: reservation.id } }
                ]
              }
            }
          ]
        }
      }
      msg_content = msg_content.try(:with_indifferent_access)
      Normalizer::MessageNormalizer.new(msg_content).perform
      message = Messages::MessageBuilder.new(@friend, @friend.channel, { message: msg_content }.try(:with_indifferent_access)).perform
      LineApi::PushMessage.new(@friend.line_account).perform([message.content], @friend.line_user_id)
  end
end
