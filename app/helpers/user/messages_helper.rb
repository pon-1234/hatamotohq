# frozen_string_literal: true

module User::MessagesHelper
  # Check if any action contains a survey action
  def contain_survey_action?(messages)
    messages.extend Hashie::Extensions::DeepLocate
    survey_actions = messages.deep_locate -> (key, value, object) { key.eql?('type') && value.eql?('survey') }
    !survey_actions.blank?
  end

  # Generate survey url before sending to each friend
  def gen_survey_url(survey, friend_id)
    routes = Rails.application.routes.url_helpers
    routes.new_survey_answer_form_url(code: survey.code, friend_id: friend_id)
  end

  def normalize_messages_with_survey_action(channel, messages)
    messages.extend Hashie::Extensions::DeepLocate
    # Find all postback action
    survey_actions = messages.deep_locate -> (key, value, object) { key.eql?('type') && value.eql?('survey') }
    survey_actions.each do |action|
      survey_id = action['content']['id']
      survey = Survey.find(survey_id)
      survey_url = gen_survey_url(survey, channel.line_friend.line_user_id)
      action['type'] = 'uri'
      action['uri'] = survey_url
      action['linkUri'] = survey_url
    end
    messages
  end
end
