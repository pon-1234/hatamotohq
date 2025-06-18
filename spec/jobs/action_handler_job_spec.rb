# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ActionHandlerJob, type: :job do
  let(:agency) { create(:agency) }
  let(:client) { create(:client, agency: agency) }
  let(:line_account) { create(:line_account, client: client) }
  let(:line_friend) { create(:line_friend, line_account: line_account) }
  let(:channel) { create(:channel, line_account: line_account, line_friend: line_friend) }
  let(:job) { described_class.new }
  
  before do
    ActiveJob::Base.queue_adapter = :test
    # Ensure channel exists for the friend
    line_friend.channel
  end

  describe '#perform' do
    context 'with display text' do
      let(:action) { { 'displayText' => 'Hello World' } }

      it 'creates a text message' do
        expect_any_instance_of(Messages::MessageBuilder).to receive(:perform)
        job.perform(line_friend, action)
      end

      it 'passes correct parameters to MessageBuilder' do
        expect(Messages::MessageBuilder).to receive(:new).with(
          line_friend,
          line_friend.channel,
          hash_including(message: hash_including(type: 'text', text: 'Hello World'))
        ).and_call_original
        allow_any_instance_of(Messages::MessageBuilder).to receive(:perform)
        
        job.perform(line_friend, action)
      end
    end

    context 'with single action' do
      context 'text action' do
        let(:action) do
          {
            'action' => {
              'type' => 'text',
              'content' => 'Test message'
            }
          }
        end

        it 'delegates to SendTextMessageHandler' do
          expect(Postback::SendTextMessageHandler).to receive(:new)
            .with(line_friend, 'Test message', nil)
            .and_call_original
          expect_any_instance_of(Postback::SendTextMessageHandler).to receive(:perform)
          
          job.perform(line_friend, action)
        end

        context 'with reply token' do
          it 'passes reply token to handler' do
            expect(Postback::SendTextMessageHandler).to receive(:new)
              .with(line_friend, 'Test message', 'reply_token_123')
              .and_call_original
            expect_any_instance_of(Postback::SendTextMessageHandler).to receive(:perform)
            
            job.perform(line_friend, action, 'reply_token_123')
          end
        end
      end

      context 'email action' do
        let(:action) do
          {
            'action' => {
              'type' => 'email',
              'content' => { 'to' => 'test@example.com' }
            }
          }
        end

        it 'delegates to SendMailHandler' do
          expect(Postback::SendMailHandler).to receive(:new)
            .with(line_friend, { 'to' => 'test@example.com' })
            .and_call_original
          expect_any_instance_of(Postback::SendMailHandler).to receive(:perform)
          
          job.perform(line_friend, action)
        end
      end

      context 'scenario action' do
        let(:action) do
          {
            'action' => {
              'type' => 'scenario',
              'content' => { 'scenario_id' => 123 }
            }
          }
        end

        it 'delegates to SendScenarioHandler' do
          expect(Postback::SendScenarioHandler).to receive(:new)
            .with(line_friend, { 'scenario_id' => 123 })
            .and_call_original
          expect_any_instance_of(Postback::SendScenarioHandler).to receive(:perform)
          
          job.perform(line_friend, action)
        end
      end

      context 'template action' do
        let(:action) do
          {
            'action' => {
              'type' => 'template',
              'content' => { 'template_id' => 456 }
            }
          }
        end

        it 'delegates to SendTemplateHandler' do
          expect(Postback::SendTemplateHandler).to receive(:new)
            .with(line_friend, { 'template_id' => 456 })
            .and_call_original
          expect_any_instance_of(Postback::SendTemplateHandler).to receive(:perform)
          
          job.perform(line_friend, action)
        end
      end

      context 'tag action' do
        let(:action) do
          {
            'action' => {
              'type' => 'tag',
              'content' => { 'tag_id' => 789, 'action' => 'assign' }
            }
          }
        end

        it 'delegates to AssignOrUnassignTagHandler' do
          expect(Postback::AssignOrUnassignTagHandler).to receive(:new)
            .with(line_friend, { 'tag_id' => 789, 'action' => 'assign' })
            .and_call_original
          expect_any_instance_of(Postback::AssignOrUnassignTagHandler).to receive(:perform)
          
          job.perform(line_friend, action)
        end
      end

      context 'reminder action' do
        let(:action) do
          {
            'action' => {
              'type' => 'reminder',
              'content' => { 'time' => '10:00' }
            }
          }
        end

        it 'delegates to SetupReminderHandler' do
          expect(Postback::SetupReminderHandler).to receive(:new)
            .with(line_friend, { 'time' => '10:00' })
            .and_call_original
          expect_any_instance_of(Postback::SetupReminderHandler).to receive(:perform)
          
          job.perform(line_friend, action)
        end
      end

      context 'scoring action' do
        let(:action) do
          {
            'action' => {
              'type' => 'scoring',
              'content' => { 'score' => 5 }
            }
          }
        end

        it 'delegates to ScoringHandler' do
          expect(Postback::ScoringHandler).to receive(:new)
            .with(line_friend, { 'score' => 5 })
            .and_call_original
          expect_any_instance_of(Postback::ScoringHandler).to receive(:perform)
          
          job.perform(line_friend, action)
        end
      end

      context 'service_review action' do
        let(:action) do
          {
            'action' => {
              'type' => 'service_review',
              'content' => { 'service_id' => 101 }
            }
          }
        end

        it 'delegates to SendServiceReviewFormHandler' do
          expect(Postback::SendServiceReviewFormHandler).to receive(:new)
            .with(line_friend, { 'service_id' => 101 })
            .and_call_original
          expect_any_instance_of(Postback::SendServiceReviewFormHandler).to receive(:perform)
          
          job.perform(line_friend, action)
        end
      end

      context 'assign_staff action' do
        let(:action) do
          {
            'action' => {
              'type' => 'assign_staff',
              'content' => { 'staff_id' => 202 }
            }
          }
        end

        it 'delegates to AssignStaffHandler' do
          expect(Postback::AssignStaffHandler).to receive(:new)
            .with(line_friend, { 'staff_id' => 202 })
            .and_call_original
          expect_any_instance_of(Postback::AssignStaffHandler).to receive(:perform)
          
          job.perform(line_friend, action)
        end
      end
    end

    context 'with multiple actions' do
      let(:action) do
        {
          'actions' => [
            { 'type' => 'text', 'content' => 'First message' },
            { 'type' => 'template', 'content' => { 'template_id' => 123 } },
            { 'type' => 'tag', 'content' => { 'tag_id' => 456 } }
          ]
        }
      end

      it 'processes all actions in order' do
        text_handler = double('text_handler')
        template_handler = double('template_handler')
        tag_handler = double('tag_handler')
        
        expect(Postback::SendTextMessageHandler).to receive(:new)
          .with(line_friend, 'First message', nil)
          .and_return(text_handler)
        expect(text_handler).to receive(:perform)
        
        expect(Postback::SendTemplateHandler).to receive(:new)
          .with(line_friend, { 'template_id' => 123 })
          .and_return(template_handler)
        expect(template_handler).to receive(:perform)
        
        expect(Postback::AssignOrUnassignTagHandler).to receive(:new)
          .with(line_friend, { 'tag_id' => 456 })
          .and_return(tag_handler)
        expect(tag_handler).to receive(:perform)
        
        job.perform(line_friend, action)
      end

      it 'adds delay between actions' do
        allow_any_instance_of(Postback::SendTextMessageHandler).to receive(:perform)
        allow_any_instance_of(Postback::SendTemplateHandler).to receive(:perform)
        allow_any_instance_of(Postback::AssignOrUnassignTagHandler).to receive(:perform)
        
        expect(job).to receive(:sleep).with(0.1).exactly(3).times
        
        job.perform(line_friend, action)
      end

      context 'with reply token' do
        it 'uses reply token only for first action' do
          expect(Postback::SendTextMessageHandler).to receive(:new)
            .with(line_friend, 'First message', 'reply_token_123')
            .and_call_original
          allow_any_instance_of(Postback::SendTextMessageHandler).to receive(:perform)
          
          expect(Postback::SendTemplateHandler).to receive(:new)
            .with(line_friend, { 'template_id' => 123 })
            .and_call_original
          allow_any_instance_of(Postback::SendTemplateHandler).to receive(:perform)
          
          allow_any_instance_of(Postback::AssignOrUnassignTagHandler).to receive(:perform)
          
          job.perform(line_friend, action, 'reply_token_123')
        end
      end
    end

    context 'with both display text and actions' do
      let(:action) do
        {
          'displayText' => 'Display this first',
          'action' => {
            'type' => 'text',
            'content' => 'Then send this'
          }
        }
      end

      it 'processes display text first then action' do
        # Verify MessageBuilder is called first
        message_builder = double('message_builder')
        expect(Messages::MessageBuilder).to receive(:new)
          .with(line_friend, line_friend.channel, hash_including(message: hash_including(type: 'text', text: 'Display this first')))
          .and_return(message_builder)
        expect(message_builder).to receive(:perform)
        
        # Then verify handler is called
        text_handler = double('text_handler')
        expect(Postback::SendTextMessageHandler).to receive(:new)
          .with(line_friend, 'Then send this', nil)
          .and_return(text_handler)
        expect(text_handler).to receive(:perform)
        
        job.perform(line_friend, action)
      end
    end

    context 'with unknown action type' do
      let(:action) do
        {
          'action' => {
            'type' => 'unknown_type',
            'content' => 'some content'
          }
        }
      end

      it 'does not raise error' do
        expect { job.perform(line_friend, action) }.not_to raise_error
      end
    end

    context 'with reservation-related actions' do
      it 'handles precheckin action' do
        action = { 'action' => { 'type' => 'precheckin', 'content' => {} } }
        expect(Postback::SendPrecheckinHandler).to receive(:new).and_call_original
        expect_any_instance_of(Postback::SendPrecheckinHandler).to receive(:perform)
        
        job.perform(line_friend, action)
      end

      it 'handles rsv_intro action' do
        action = { 'action' => { 'type' => 'rsv_intro', 'content' => {} } }
        expect(Postback::SendReservationInstructionHandler).to receive(:new).and_call_original
        expect_any_instance_of(Postback::SendReservationInstructionHandler).to receive(:perform)
        
        job.perform(line_friend, action)
      end

      it 'handles rsv_bookmark action' do
        action = { 'action' => { 'type' => 'rsv_bookmark', 'content' => {} } }
        expect(Postback::CreateRsvBookmarkHandler).to receive(:new).and_call_original
        expect_any_instance_of(Postback::CreateRsvBookmarkHandler).to receive(:perform)
        
        job.perform(line_friend, action)
      end

      it 'handles rsv_cancel_intro action' do
        action = { 'action' => { 'type' => 'rsv_cancel_intro', 'content' => {} } }
        expect(Postback::SendRsvCancellationIntroHandler).to receive(:new).and_call_original
        expect_any_instance_of(Postback::SendRsvCancellationIntroHandler).to receive(:perform)
        
        job.perform(line_friend, action)
      end

      it 'handles rsv_rm_bookmark action' do
        action = { 'action' => { 'type' => 'rsv_rm_bookmark', 'content' => {} } }
        expect(Postback::RemoveRsvBookmarkHandler).to receive(:new).and_call_original
        expect_any_instance_of(Postback::RemoveRsvBookmarkHandler).to receive(:perform)
        
        job.perform(line_friend, action)
      end

      it 'handles rsv_contact action' do
        action = { 'action' => { 'type' => 'rsv_contact', 'content' => {} } }
        expect(Postback::ContactRsvHandler).to receive(:new).and_call_original
        expect_any_instance_of(Postback::ContactRsvHandler).to receive(:perform)
        
        job.perform(line_friend, action)
      end
    end
  end

  describe 'job configuration' do
    it 'is queued in default queue' do
      expect(described_class.new.queue_name).to eq('default')
    end

    it 'has retry disabled' do
      expect(described_class.sidekiq_options['retry']).to be false
    end
  end
end