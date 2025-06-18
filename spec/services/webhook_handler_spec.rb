# frozen_string_literal: true

require 'rails_helper'

RSpec.describe WebhookHandler do
  before do
    ActiveJob::Base.queue_adapter = :test
    line_bot_client = double('Line::Bot::Client')
    allow(line_bot_client).to receive(:get_profile).and_return(nil)
    stub_const('Line::Bot::Client', Class.new do
      define_method :initialize do |&block|
        # Do nothing
      end
      
      define_method :get_profile do |user_id|
        nil
      end
    end)
  end
  let(:webhook_handler) { described_class.new }
  let(:agency) { create(:agency) }
  let(:client) { create(:client, agency: agency) }
  let(:line_account) { create(:line_account, client: client, webhook_url: 'test_webhook_key') }
  
  def to_webhook_event(event)
    # WebhookHandler expects a mix of symbol and string keys
    # Top level uses symbols, nested message data uses strings
    {
      type: event[:type],
      source: event[:source],
      message: event[:message]&.deep_stringify_keys,
      postback: event[:postback]&.deep_stringify_keys
    }.compact
  end
  let(:line_friend) { create(:line_friend, line_account: line_account, line_user_id: 'U123456789') }
  let(:channel) { create(:channel, line_account: line_account, line_friend: line_friend) }
  
  let(:user_id) { 'U123456789' }
  let(:webhook_key) { 'test_webhook_key' }
  
  describe '#handle_event' do
    context 'when line_account is not found' do
      it 'returns nil' do
        event = { type: 'message', source: { userId: user_id } }
        result = webhook_handler.handle_event(event, 'invalid_key')
        expect(result).to be_nil
      end
    end

    context 'when line_account is found' do
      before do
        line_account
      end

      context 'with follow event' do
        let(:follow_event) do
          {
            type: 'follow',
            source: { userId: 'U987654321' }
          }
        end

        let(:profile_response) do
          {
            'userId' => 'U987654321',
            'displayName' => 'Test User',
            'pictureUrl' => 'https://example.com/picture.jpg'
          }
        end

        before do
          allow_any_instance_of(LineApi::GetProfile).to receive(:perform).and_return(profile_response)
          allow_any_instance_of(Messages::SystemLogBuilder).to receive(:perform_follow)
        end

        it 'creates a new friend and channel' do
          expect {
            webhook_handler.handle_event(to_webhook_event(follow_event), webhook_key)
          }.to change { LineFriend.count }.by(1)
            .and change { Channel.count }.by(1)
        end

        it 'sets friend status to active' do
          webhook_handler.handle_event(to_webhook_event(follow_event), webhook_key)
          friend = LineFriend.find_by(line_user_id: 'U987654321')
          expect(friend.status).to eq('active')
        end

        it 'creates system log for follow event' do
          expect_any_instance_of(Messages::SystemLogBuilder).to receive(:perform_follow)
          webhook_handler.handle_event(to_webhook_event(follow_event), webhook_key)
        end
      end

      context 'with unfollow event' do
        let(:unfollow_event) do
          {
            type: 'unfollow',
            source: { userId: user_id }
          }
        end

        before do
          line_friend
          channel
          allow_any_instance_of(Messages::SystemLogBuilder).to receive(:perform_unfollow)
          allow(channel).to receive(:cancel_scenarios)
        end

        it 'updates friend status to blocked' do
          webhook_handler.handle_event(to_webhook_event(unfollow_event), webhook_key)
          line_friend.reload
          expect(line_friend.status).to eq('blocked')
        end

        it 'locks the channel' do
          webhook_handler.handle_event(to_webhook_event(unfollow_event), webhook_key)
          channel.reload
          expect(channel.locked).to be_truthy
        end

        it 'creates system log for unfollow event' do
          expect_any_instance_of(Messages::SystemLogBuilder).to receive(:perform_unfollow)
          webhook_handler.handle_event(to_webhook_event(unfollow_event), webhook_key)
        end

        it 'cancels active scenarios' do
          expect_any_instance_of(Channel).to receive(:cancel_scenarios)
          webhook_handler.handle_event(to_webhook_event(unfollow_event), webhook_key)
        end
      end

      context 'with message event' do
        let(:text_message_event) do
          {
            type: 'message',
            source: { userId: user_id },
            message: {
              type: 'text',
              text: 'Hello',
              contentProvider: {
                type: 'external'
              }
            }
          }
        end

        context 'when friend exists' do
          before do
            line_friend
            channel
            allow_any_instance_of(Messages::MessageBuilder).to receive(:perform).and_return(double(content: {}))
            allow(webhook_handler).to receive(:is_from_app?).and_return(false)
          end

          it 'creates a message' do
            expect_any_instance_of(Messages::MessageBuilder).to receive(:perform)
            webhook_handler.handle_event(to_webhook_event(text_message_event), webhook_key)
          end

          it 'does not create new friend' do
            allow(webhook_handler).to receive(:is_from_app?).and_return(false)
            expect {
              webhook_handler.handle_event(to_webhook_event(text_message_event), webhook_key)
            }.not_to change { LineFriend.count }
          end
        end

        context 'when friend does not exist' do
          let(:profile_response) do
            {
              'userId' => user_id,
              'displayName' => 'New User',
              'pictureUrl' => 'https://example.com/picture.jpg'
            }
          end

          before do
            allow_any_instance_of(LineApi::GetProfile).to receive(:perform).and_return(profile_response)
            allow_any_instance_of(Messages::MessageBuilder).to receive(:perform).and_return(double(content: {}))
            allow_any_instance_of(described_class).to receive(:is_from_app?).and_return(false)
          end

          it 'creates a new friend' do
            expect {
              webhook_handler.handle_event(to_webhook_event(text_message_event), webhook_key)
            }.to change { LineFriend.count }.by(1)
          end
        end

        context 'when channel is locked' do
          before do
            line_friend
            channel.update(locked: true)
          end

          it 'does not create a message' do
            expect_any_instance_of(Messages::MessageBuilder).not_to receive(:perform)
            webhook_handler.handle_event(to_webhook_event(text_message_event), webhook_key)
          end
        end

        context 'when message is from bot itself' do
          let(:bot_message_event) do
            {
              type: 'message',
              source: { userId: 'BOT123456789' },
              message: {
                type: 'text',
                text: 'Hello',
                contentProvider: {
                  type: 'external'
                }
              }
            }
          end
          
          before do
            line_account.update(line_user_id: 'BOT123456789')
            line_friend.update(line_user_id: 'BOT123456789')
            channel
          end

          it 'does not create a message' do
            expect_any_instance_of(Messages::MessageBuilder).not_to receive(:perform)
            webhook_handler.handle_event(to_webhook_event(bot_message_event), webhook_key)
          end
        end
      end

      context 'with postback event' do
        let(:postback_event) do
          {
            type: 'postback',
            source: { userId: user_id },
            postback: {
              data: 'action_key_123'
            }
          }
        end

        context 'when postback has datetime params' do
          let(:datetime_postback_event) do
            {
              type: 'postback',
              source: { userId: user_id },
              postback: {
                data: 'datetime_action',
                params: {
                  datetime: '2023-12-01T14:30'
                }
              }
            }
          end

          before do
            line_friend
            channel
            allow_any_instance_of(Messages::MessageBuilder).to receive(:perform)
              .and_return(double(content: { type: 'text', text: '2023-12-01 14:30' }))
            allow_any_instance_of(LineApi::PushMessage).to receive(:perform)
          end

          it 'handles datetime selection' do
            expect_any_instance_of(LineApi::PushMessage).to receive(:perform)
            webhook_handler.handle_event(to_webhook_event(datetime_postback_event), webhook_key)
          end

          it 'formats datetime correctly' do
            expect_any_instance_of(Messages::MessageBuilder).to receive(:perform).with(
              nil,
              channel,
              hash_including(message: hash_including(text: '2023-12-01 14:30'))
            ).and_return(double(content: { type: 'text', text: '2023-12-01 14:30' }))
            webhook_handler.handle_event(to_webhook_event(datetime_postback_event), webhook_key)
          end
        end

        context 'when postback has mapped action' do
          let(:postback_mapper) { create(:postback_mapper, key: 'action_key_123', value: { action: 'test_action' }) }

          before do
            postback_mapper
            allow_any_instance_of(PostbackHandler).to receive(:perform)
          end

          it 'delegates to PostbackHandler' do
            expect(PostbackHandler).to receive(:new)
              .with(line_account, postback_event, { 'action' => 'test_action' })
              .and_call_original
            expect_any_instance_of(PostbackHandler).to receive(:perform)
            
            webhook_handler.handle_event(to_webhook_event(postback_event), webhook_key)
          end
        end

        context 'when postback has no mapped action' do
          it 'does not delegate to PostbackHandler' do
            expect(PostbackHandler).not_to receive(:new)
            webhook_handler.handle_event(to_webhook_event(postback_event), webhook_key)
          end
        end
      end

      context 'with media message event' do
        let(:image_message_event) do
          {
            type: 'message',
            source: { userId: user_id },
            message: {
              type: 'image',
              id: 'MSG123456789',
              contentProvider: {
                type: 'line'
              }
            }
          }
        end

        let(:media_content) { 'fake_image_binary_data' }
        let(:http_response) { double('response', body: media_content) }
        
        before do
          line_friend
          channel
          allow_any_instance_of(LineApi::GetContent).to receive(:perform).and_return(http_response)
          allow(Net::HTTPSuccess).to receive(:===).with(http_response).and_return(true)
          allow_any_instance_of(Messages::MessageBuilder).to receive(:perform)
        end

        it 'downloads and stores media' do
          expect {
            webhook_handler.handle_event(to_webhook_event(image_message_event), webhook_key)
          }.to change { Media.count }.by(1)
        end

        it 'updates message with media URLs' do
          webhook_handler.handle_event(to_webhook_event(image_message_event), webhook_key)
          
          media = Media.last
          expect(media.type).to eq('image')
          expect(media.provider).to eq('line')
        end
      end
    end
  end
end