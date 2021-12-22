# frozen_string_literal: true

class ActionHandlerJob < ApplicationJob
  sidekiq_options retry: false
  queue_as :default

  def perform(friend, action, reply_token = nil)
    @friend = friend
    @action = action
    @reply_token = reply_token
    # Handle multiple actions
    handle_message_action(@action['actions']) if @action['actions'].present?
    # Handle single action
    handle_message_action([@action['action']]) if @action['action'].present?
    # Create text message if friend select option contains displayText
    handle_display_text(@action['displayText']) if @action['displayText'].present?
  end


  private
    def handle_message_action(actions)
      actions.each do |action|
        case action['type']
        when 'text'
          send_text_message(action['content'])
        when 'email'
          send_email(action['content'])
        when 'scenario'
          send_scenario(action['content'])
        when 'template'
          send_template(action['content'])
        when 'tag'
          handle_tag_action(action['content'])
        when 'reminder'
          setup_reminder(action['content'])
        when 'reservation'
          send_reservation_introduction
        end
      end
    end

    def handle_display_text(text)
      Messages::MessageBuilder.new(@friend, @friend.channel, { message: { type: 'text', text: text } }.try(:with_indifferent_access)).perform
    end

    def send_text_message(content)
      messages = [{ type: 'text', text: content['text'] }]
      # Rebuild payload
      payload = {
        channel_id: @friend.channel.id,
        reply_token: @reply_token,
        messages: messages
      }
      PushMessageToLineJob.perform_later(payload)
    end

    def send_email(content)
      UserMailer.postback_email(@friend.id, content).deliver_later
    end

    def send_scenario(content)
      scenario_id = content['scenario_id']
      ScenarioSchedulerJob.perform_later(@friend.channel.id, scenario_id)
    end

    def send_template(content)
      template_id = content['template_id']
      SendTemplateJob.perform_later(@friend.channel.id, template_id)
    end

    def setup_reminder(content)
      type = content['type']
      set_reminder(content) if type == 'set'
      unset_reminder(content) if type == 'unset'
    end

    def send_reservation_introduction
      routes = Rails.application.routes.url_helpers
      form_url = routes.reservation_inquiry_form_url(friend_id: @friend.line_user_id)
      text =  "Please access this url to continue booking #{form_url}"
      message = Messages::MessageBuilder.new(@friend, @friend.channel, { message: { type: 'text', text: text } }.try(:with_indifferent_access)).perform
      LineApi::PushMessage.new(@friend.line_account).perform([message.content], @friend.line_user_id)
    end

    def set_reminder(content)
      goal = content['goal']
      reminder_id = content['reminder']['id']
      reminder = Reminder.find(reminder_id)
      # Cancel all active reminding
      active_remindings = reminder.remindings.where("remindings.channel_id = ? AND remindings.status = 'active'", @friend.channel.id)
      active_remindings.includes([:channel, :reminder_events]).each { |_| _.cancel }
      # Start a new reminding
      reminding = Reminding.new(channel: @friend.channel, reminder: reminder, goal: goal, status: 'active')
      reminding.save!
    end

    def unset_reminder(content)
      reminder_id = content['reminder']['id']
      reminder = Reminder.find(reminder_id)
      remindings = reminder.remindings.where('remindings.channel_id = ?', @friend.channel.id)
      remindings.each do |reminding|
        reminding.cancel
      end
    end

    def handle_tag_action(tag_actions)
      assign_action = tag_actions.find { |action| action['type'] == 'assign' }
      unassign_action = tag_actions.find { |action| action['type'] == 'unassign' }
      assign_tag(assign_action) if assign_action.present?
      unassign_tag(unassign_action) if unassign_action.present?
    end

    def assign_tag(action)
      assign_ids = action['tags'].pluck('id')
      # to avoid exception, check existing before save
      tag_ids = Tag.where(id: assign_ids).pluck(:id)
      @friend.tag_ids = @friend.tag_ids | tag_ids
      @friend.save!
    end

    def unassign_tag(action)
      unassign_ids = action['tags'].pluck('id')
      @friend.tag_ids = @friend.tag_ids - unassign_ids
      @friend.save!
    end
end
