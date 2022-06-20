# frozen_string_literal: true

module FolderType
  extend ActiveSupport::Concern

  included do
    enum type: {
      tag: 'tag',
      template_message: 'template_message',
      auto_response: 'auto_response',
      rich_menu: 'rich_menu',
      scenario: 'scenario',
      scenario_template: 'scenario_template',
      variable: 'variable',
      survey: 'survey',
      flex_message: 'flex_message',
      reminder: 'reminder',
      site: 'site',
      stream_route: 'stream_route'
    }, _prefix: :type
  end
end
