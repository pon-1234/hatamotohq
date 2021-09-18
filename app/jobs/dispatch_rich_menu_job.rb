# frozen_string_literal: true

require 'tempfile'
require 'open-uri'

class DispatchRichMenuJob < ApplicationJob
  queue_as :default

  def perform(richmenu_id)
    @richmenu = RichMenu.find(richmenu_id)
    @line_account = @richmenu.line_account
    friend_ids = @line_account.line_friends.pluck(:line_user_id)
    Normalizer::PostbackNormalizer.new(@richmenu.areas).perform

    return unless post_create_richmenu
    return unless post_create_richmenu_content
  end

  private
    # Send request to line api to create a new richmenu
    def post_create_richmenu
      response = LineApi::PostRichmenu.new(@line_account).perform(richmenu_payload)
      if response.code == '200'
        # Update rich menu id
        json_body = JSON.parse(response.body)
        richmenu_id = json_body['richMenuId']
        @richmenu.update_columns(line_menu_id: richmenu_id)
        true
      else
        @richmenu.update_columns(status: 'error')
        false
      end
    end

    # Upload richmenu image to line
    def post_create_richmenu_content
      image_url = @richmenu.image_url
      response = LineApi::PostRichmenuContent.new(@line_account).perform(@richmenu.line_menu_id, URI.parse(image_url).open)
    end

    def richmenu_payload
      {
        size: @richmenu.size,
        selected: @richmenu.selected,
        name: @richmenu.name,
        chatBarText: @richmenu.chat_bar_text,
        areas: @richmenu.areas
      }
    end
end
