# frozen_string_literal: true

module User::MessagesHelper
  # Check if any action contains a survey action
  def contain_survey_action?(messages)
    messages.extend Hashie::Extensions::DeepLocate
    survey_actions = messages.deep_locate -> (key, value, object) { key.eql?('type') && value.eql?('survey') }
    !survey_actions.blank?
  end
end
