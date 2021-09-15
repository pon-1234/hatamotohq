# frozen_string_literal: true

class PostbackHandler
  def initialize(line_account, event, action)
    @line_account = line_account
    @event = event
    @action = action
    friend_id = @event[:source][:userId]
    @friend = LineFriend.find_by(line_account: @line_account, line_user_id: friend_id)
    @reply_token = @event['replyToken']
  end

  def perform
    handle_message_action(@action['messages']) if @action['messages'].present?
    handle_tag_action(@action['tag']) if @action['tag'].present?
  end

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
      end
    end
  end

  def handle_tag_action(tag_actions)
    assign_action = tag_actions.find { |action| action['type'] == 'assign' }
    unassign_action = tag_actions.find { |action| action['type'] == 'unassign' }
    assign_tag(assign_action) if assign_action.present?
    unassign_tag(unassign_action) if unassign_action.present?
  end

  private
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

    def assign_tag(action)
      assign_ids = action['tags'].pluck('id')
      @friend.tag_ids = @friend.tag_ids | assign_ids
      @friend.save!
    end

    def unassign_tag(action)
      unassign_ids = action['tags'].pluck('id')
      @friend.tag_ids = @friend.tag_ids - unassign_ids
      @friend.save!
    end
end
