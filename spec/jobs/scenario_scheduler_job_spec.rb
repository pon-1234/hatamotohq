# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ScenarioSchedulerJob, type: :job do
  let(:agency) { create(:agency) }
  let(:client) { create(:client, agency: agency) }
  let(:line_account) { create(:line_account, client: client) }
  let(:line_friend) { create(:line_friend, line_account: line_account) }
  let(:channel) { create(:channel, line_account: line_account, line_friend: line_friend) }
  let(:scenario) { create(:scenario, line_account: line_account, mode: 'time') }
  let(:job) { described_class.new }
  
  before do
    ActiveJob::Base.queue_adapter = :test
    # Mock helper modules
    allow(job).to receive(:begin_sending_scenario_statistic)
    allow(job).to receive(:after_sending_scenario_statistic)
    allow(job).to receive(:update_site_measurement_statistic)
    allow(job).to receive(:attach_shorten_url_to_message)
    allow(job).to receive(:contain_survey_action?).and_return(false)
  end

  describe '#perform' do
    context 'when scenario is already running for the friend' do
      before do
        create(:scenario_friend, scenario: scenario, line_friend: line_friend, status: 'running')
      end

      it 'does not send scenario messages' do
        expect(job).not_to receive(:schedule)
        job.perform(channel.id, scenario.id)
      end
    end

    context 'when scenario has no enabled messages' do
      it 'does not send scenario messages' do
        expect(job).not_to receive(:schedule)
        job.perform(channel.id, scenario.id)
      end
    end

    context 'when scenario has enabled messages' do
      let!(:scenario_message1) do
        create(:scenario_message, 
          scenario: scenario, 
          step: 0, 
          date: 0,
          time: '00:00',
          content: { type: 'text', text: 'First message' },
          status: 'enabled',
          is_initial: true
        )
      end
      
      let!(:scenario_message2) do
        create(:scenario_message, 
          scenario: scenario, 
          step: 1, 
          date: 1,
          time: '10:00',
          content: { type: 'text', text: 'Second message' },
          status: 'enabled',
          is_initial: false
        )
      end

      before do
        scenario.update(after_action: { 'data' => { 'action' => { 'type' => 'text', 'content' => 'Final action' } } })
        allow_any_instance_of(Messages::SystemLogBuilder).to receive(:perform_scenario_start)
        allow_any_instance_of(Messages::SystemLogBuilder).to receive(:perform_scenario_end)
      end

      it 'begins sending scenario statistic' do
        expect(job).to receive(:begin_sending_scenario_statistic).with(scenario, line_friend, anything)
        job.perform(channel.id, scenario.id)
      end

      it 'saves scenario started log' do
        expect_any_instance_of(Messages::SystemLogBuilder).to receive(:perform_scenario_start).with(scenario)
        job.perform(channel.id, scenario.id)
      end

      it 'schedules all enabled messages' do
        expect(job).to receive(:schedule).exactly(2).times
        job.perform(channel.id, scenario.id)
      end

      it 'schedules after action' do
        expect(job).to receive(:schedule_after_action)
        job.perform(channel.id, scenario.id)
      end

      context 'with initial message (step 0)' do
        it 'delivers immediately' do
          expect(PushMessageToLineJob).to receive(:perform_now).with(
            hash_including(
              channel_id: channel.id,
              messages: [{ type: 'text', text: 'First message' }]
            )
          )
          job.perform(channel.id, scenario.id)
        end

        it 'updates scenario statistics after sending' do
          allow(PushMessageToLineJob).to receive(:perform_now)
          expect(job).to receive(:after_sending_scenario_statistic).at_least(:once)
          job.perform(channel.id, scenario.id)
        end
      end

      context 'with scheduled message (step > 0)' do
        before do
          scenario_message1.update(step: 1)
        end

        it 'creates scenario event for future delivery' do
          expect {
            job.perform(channel.id, scenario.id)
          }.to change { ScenarioEvent.count }.by(3) # 2 messages + 1 after action
        end

        it 'sets correct schedule time for time mode' do
          job.perform(channel.id, scenario.id)
          
          event = ScenarioEvent.find_by(scenario_message: scenario_message2)
          expect(event.schedule_at.hour).to eq(10)
          expect(event.schedule_at.min).to eq(0)
        end
      end

      context 'with elapsed_time mode' do
        before do
          scenario.update(mode: 'elapsed_time')
        end

        it 'calculates delivery time based on elapsed time' do
          allow(Time.zone).to receive(:now).and_return(Time.zone.parse('2024-01-01 09:00:00'))
          
          job.perform(channel.id, scenario.id)
          
          # First message should be immediate (step 0)
          expect(PushMessageToLineJob).to have_received(:perform_now)
          
          # Second message should be scheduled for 1 day + 10 hours later
          event = ScenarioEvent.find_by(scenario_message: scenario_message2)
          expect(event.schedule_at).to eq(Time.zone.parse('2024-01-02 19:00:00'))
        end
      end

      context 'with site measurements' do
        let(:site) { create(:site, line_account: line_account) }
        let(:site_measurement) { create(:site_measurement, site: site) }
        
        before do
          scenario_message1.site_measurements << site_measurement
        end

        it 'attaches shorten URL to message' do
          expect(job).to receive(:attach_shorten_url_to_message)
            .with(scenario_message1, site_measurement, line_friend.line_user_id)
          
          allow(PushMessageToLineJob).to receive(:perform_now)
          job.perform(channel.id, scenario.id)
        end

        it 'updates site measurement statistics' do
          allow(PushMessageToLineJob).to receive(:perform_now)
          expect(job).to receive(:update_site_measurement_statistic)
            .with([scenario_message1], [line_friend])
          
          job.perform(channel.id, scenario.id)
        end
      end

      context 'with survey action' do
        before do
          scenario_message1.update(content: { type: 'survey', survey_id: 123 })
          allow(job).to receive(:contain_survey_action?).and_return(true)
          allow(job).to receive(:normalize_messages_with_survey_action).and_return({ type: 'normalized_survey' })
        end

        it 'normalizes messages with survey action' do
          expect(job).to receive(:normalize_messages_with_survey_action)
            .with(channel, scenario_message1.content)
          
          allow(PushMessageToLineJob).to receive(:perform_now)
          job.perform(channel.id, scenario.id)
        end
      end

      context 'with after action' do
        context 'when last message is initial' do
          before do
            scenario_message2.update(step: 0)
          end

          it 'performs after action immediately' do
            allow(PushMessageToLineJob).to receive(:perform_now)
            expect(ActionHandlerJob).to receive(:perform_now)
              .with(line_friend, scenario.after_action['data'])
            
            job.perform(channel.id, scenario.id)
          end

          it 'saves scenario ended log' do
            allow(PushMessageToLineJob).to receive(:perform_now)
            allow(ActionHandlerJob).to receive(:perform_now)
            
            expect_any_instance_of(Messages::SystemLogBuilder).to receive(:perform_scenario_end).with(scenario)
            job.perform(channel.id, scenario.id)
          end
        end

        context 'when last message is scheduled' do
          it 'creates after action event' do
            expect {
              job.perform(channel.id, scenario.id)
            }.to change { ScenarioEvent.where(type: 'after_action').count }.by(1)
          end

          it 'marks after action event as last' do
            job.perform(channel.id, scenario.id)
            
            after_action_event = ScenarioEvent.find_by(type: 'after_action')
            expect(after_action_event.is_last).to be true
          end
        end
      end

      context 'with message normalization' do
        it 'normalizes message content' do
          allow(Normalizer::MessageNormalizer).to receive(:new).and_call_original
          expect(Normalizer::MessageNormalizer).to receive(:new)
            .with(scenario_message1.content, line_friend)
            .at_least(:once)
          
          allow(PushMessageToLineJob).to receive(:perform_now)
          job.perform(channel.id, scenario.id)
        end
      end
    end

    context 'error handling' do
      let!(:scenario_message) do
        create(:scenario_message, 
          scenario: scenario, 
          step: 0, 
          content: { type: 'text', text: 'Test' },
          status: 'enabled',
          is_initial: true
        )
      end

      it 'does not retry on failure' do
        expect(described_class.sidekiq_options['retry']).to be false
      end

      it 'raises error when channel not found' do
        expect {
          job.perform(999999, scenario.id)
        }.to raise_error(ActiveRecord::RecordNotFound)
      end

      it 'raises error when scenario not found' do
        expect {
          job.perform(channel.id, 999999)
        }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end
  end

  describe 'job configuration' do
    it 'is queued in default queue' do
      expect(described_class.new.queue_name).to eq('default')
    end

    it 'includes required helper modules' do
      expect(described_class.ancestors).to include(User::MessagesHelper)
      expect(described_class.ancestors).to include(SendScenarioStatistic)
    end
  end
end