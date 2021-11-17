# frozen_string_literal: true

class SendTemplateJob < ApplicationJob
  sidekiq_options retry: false
  queue_as :default

  include Rails.application.routes.url_helpers
  include User::MessagesHelper

  def perform(channel_id, template_id)
    @channel = Channel.find(channel_id)
    template = Template.find(template_id)
    template_messages = template.template_messages
    messages = template_messages.map(&:content)
    if contain_survey_action?(messages)
      payload = {
        channel_id: channel_id,
        messages: normalize_messages_with_survey_action(messages)
      }
    else
      payload = {
        channel_id: channel_id,
        messages: messages
      }
    end
    PushMessageToLineJob.perform_now(payload)
  end

  def normalize_messages_with_survey_action(messages)
    messages.extend Hashie::Extensions::DeepLocate
    # Find all postback action
    survey_actions = messages.deep_locate -> (key, value, object) { key.eql?('type') && value.eql?('survey') }
    survey_actions.each do |action|
      survey_id = action['content']['id']
      survey = Survey.find(survey_id)
      survey_url = gen_survey_url(survey, @channel.line_friend.line_user_id)
      action['type'] = 'uri'
      action['uri'] = survey_url
      action['linkUri'] = survey_url
    end
    messages
  end

  def gen_survey_url(survey, friend_id)
    new_survey_answer_form_url(code: survey.code, friend_id: friend_id)
  end
end
