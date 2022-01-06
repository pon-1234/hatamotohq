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
    # TODO seperate handler for each postback action
    def handle_message_action(actions)
      actions.each do |action|
        action_content = action['content']
        case action['type']
        when 'text'
          send_text_message(action_content)
        when 'email'
          send_email(action_content)
        when 'scenario'
          send_scenario(action_content)
        when 'template'
          send_template(action_content)
        when 'tag'
          handle_tag_action(action_content)
        when 'reminder'
          setup_reminder(action_content)
        when 'reservation'
          send_reservation_introduction
        when 'rsv_bookmark'
          handle_rsv_bookmark_action(action_content)
        when 'rsv_cancel'
          handle_rsv_cancel_action
        when 'rm_bookmark'
          handle_rm_bookmark(action_content)
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
      SystemMailer.postback_email(@friend.id, content).deliver_later
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
      form_url = routes.reservation_inquiry_form_url(friend_line_id: @friend.line_user_id)
      send_text_message("こちらのリンクにアクセスして、引き続き予約しましょう〜  #{form_url}")
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

    def handle_rsv_bookmark_action(content)
      room_id = content['roomId']
      bookmark = RsvBookmark.find_or_create_by(room_id: room_id, line_friend: @friend, status: :wait)
      # Send message inform user that the room is bookmarked
      send_text_message('お気に入りました。空室が空いたらお知らせします。')
    end

    def handle_rsv_cancel_action
      # Send messages to confirm cancellation
      bookmarks = @friend.rsv_bookmarks.wait
      bookmarks.each do |bookmark|
        msg_content = {
          type: 'template',
          altText: '空室待ちキャンセルの確認',
          template: {
            type: 'confirm',
            text: '本当に空室待ちをキャンセルしてもよろしいですか？空室名：{roomName}',
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
                    { type: 'rm_bookmark', content: { bookmark_id: bookmark.id } }
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

    def handle_rm_bookmark(content)
      bookmark_id = content['bookmark_id']
      return if bookmark_id.nil?
      if RsvBookmark.find(bookmark_id)&.cancel
        send_text_message('空室待ちをキャンセルしました。')
      end
    end

    def send_text_message(text)
      message = Messages::MessageBuilder.new(@friend, @friend.channel, { message: { type: 'text', text: text } }.try(:with_indifferent_access)).perform
      LineApi::PushMessage.new(@friend.line_account).perform([message.content], @friend.line_user_id)
    end
end
