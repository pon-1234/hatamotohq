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

    if @richmenu.disabled?
      delete_rich_menu_if_needed if @richmenu.line_menu_id.present?
    elsif @richmenu.enabled?
      delete_rich_menu_if_needed
      create_rich_menu
      create_rich_menu_content

      if @richmenu.target_all?
        set_default_rich_menu
      else
        bulk_link_rich_menus
      end
    end
  rescue StandardError => e
    logger.error(e.message)
    @richmenu.update_columns(status: 'error')
  end

  private
    # Send request to line api to create a new richmenu
    def create_rich_menu
      response = LineApi::CreateRichMenu.new(@line_account).perform(richmenu_payload)
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
    def create_rich_menu_content
      image_url = @richmenu.image_url
      response = LineApi::CreateRichMenuImage.new(@line_account).perform(@richmenu.line_menu_id, URI.parse(image_url).open)
    end

    def set_default_rich_menu
      response = LineApi::SetDefaultRichMenu.new(@line_account).perform(@richmenu.line_menu_id)
    end

    def bulk_link_rich_menus
      tag_condition = @richmenu.conditions.detect { |condition| condition['type'].eql?('tag') }
      return false if tag_condition.blank?

      tag_ids = tag_condition['data']['tags'].pluck('id')
      LineFriend.find_all_by_tags(@line_account.id, tag_ids).find_in_batches(batch_size: 500) do |friends|
        friend_ids = friends.pluck(:line_user_id)
        LineApi::BulkLinkRichMenus.new(@line_account).perform(friend_ids, @richmenu.line_menu_id)
      end
    end

    def delete_rich_menu_if_needed
      needed = @richmenu.line_menu_id.present?
      # No need to delete if the rich menu was not registered in Line System
      return true unless needed
      # If rich menu is registered in Line System, need to cancel it before set a new one
      LineApi::DeleteRichMenu.new(@line_account).perform(@richmenu.line_menu_id)
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
