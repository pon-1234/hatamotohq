# frozen_string_literal: true

require 'tempfile'
require 'open-uri'

class DispatchRichMenuJob < ApplicationJob
  queue_as :default
  include Rails.application.routes.url_helpers
  include User::MessagesHelper

  def perform(richmenu_id)
    @richmenu = RichMenu.find(richmenu_id)
    @richmenu.clear_logs
    @line_account = @richmenu.line_account
    if @richmenu.disabled?
      disable_rich_menu
    elsif @richmenu.enabled?
      enable_rich_menu
    end
  rescue => e
    @richmenu.logs = e.message
    @richmenu.status = :error
    @richmenu.member_count = 0
  ensure
    @richmenu.save!
  end

  private
    def enable_rich_menu
      delete_rich_menu_if_needed
      success = create_rich_menu
      success = create_rich_menu_content if success
      if success
        if @richmenu.target_all?
          set_default_rich_menu
        else
          bulk_link_rich_menus
        end
      end
    end

    def disable_rich_menu
      delete_rich_menu_if_needed if @richmenu.line_menu_id.present?
    end

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
        false
      end
    end

    # Upload richmenu image to line
    def create_rich_menu_content
      image_url = @richmenu.image_url
      LineApi::CreateRichMenuImage.new(@line_account).perform(@richmenu.line_menu_id, URI.parse(image_url).open)
    end

    def set_default_rich_menu
      # unset default rich menu before set new one
      LineApi::UnsetDefaultRichMenu.new(@line_account).perform
      # Disable other default richmenu belongs to this account
      if LineApi::SetDefaultRichMenu.new(@line_account).perform(@richmenu.line_menu_id)
        @richmenu.status = :enabled
        @richmenu.member_count = @line_account.line_friends.active.count
        @line_account.rich_menus.target_all.where.not(id: @richmenu.id).update_all(status: :disabled)
      else
        @richmenu.logs = 'Could not set default richmenu'
        @richmenu.status = :error
      end
    end

    def bulk_link_rich_menus
      tag_condition = @richmenu.conditions.detect { |condition| condition['type'].eql?('tag') }
      return false if tag_condition.blank?
      tag_ids = tag_condition['data']['tags'].pluck('id')
      # count friends will be applied this rich menu
      friend_count = @line_account.line_friends.joins(:tags).references(:tags).where(tags: { id: tag_ids }).pluck(:id).uniq.count
      @richmenu.member_count = friend_count
      @richmenu.status = :enabled

      LineFriend.find_all_by_tags(@line_account.id, tag_ids).find_in_batches(batch_size: 500) do |friends|
        friend_ids = friends.pluck(:line_user_id)
        unless LineApi::BulkLinkRichMenus.new(@line_account).perform(friend_ids, @richmenu.line_menu_id)
          # Stop calling api if error occurred
          @richmenu.logs = 'Could not bulk link rich menu'
          @richmenu.status = :error
          return
        end
      end
    end

    def delete_rich_menu_if_needed
      # No need to delete if the rich menu was not registered in Line System
      return unless @richmenu.line_menu_id.present?
      # If rich menu is registered in Line System, need to cancel it before set a new one
      LineApi::DeleteRichMenu.new(@line_account).perform(@richmenu.line_menu_id)
    end

    def calc_and_set_member_count(count)
      @richmenu.update_columns(member_count: count)
    end

    def richmenu_payload
      {
        size: @richmenu.size,
        selected: @richmenu.selected,
        name: @richmenu.name,
        chatBarText: @richmenu.chat_bar_text,
        areas: Normalizer::PostbackNormalizer.new(@richmenu.areas.deep_dup).perform
      }
    end
end
