# frozen_string_literal: true

module FolderType
  extend ActiveSupport::Concern

  included do
    enum type: {
      tag: 'tag',
      message_template: 'message_template',
      auto_response: 'auto_response',
      rich_menu: 'rich_menu',
      scenario: 'scenario',
      scenario_template: 'scenario_template',
      survey: 'survey',
      survey_profile: 'survey_profile',
      flex_message: 'flex_message'
    }, _suffix: true
  end
end
