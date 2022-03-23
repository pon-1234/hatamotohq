# frozen_string_literal: true

class Api::V1::Staff::ChannelsController < Api::V1::Staff::ApplicationController
  before_action :find_channel, only: %i(scenarios update_last_seen)

  # GET /api/v1/staff/channels
  def index
    authorize! :read, Channel
    @channels = channel_finder.perform
  end

  # GET /api/v1/staff/channels/:id/scenarios
  def scenarios
    authorize! :read, @channel
    @scenarios = @channel.line_friend.manual_scenarios
  end

  # POST /api/v1/staff/channels/:id/update_last_seen
  def update_last_seen
    authorize! :update, @channel
    @channel.last_seen_at = Time.zone.now
    @channel.save!
    render_success
  end

  private
    def channel_finder
      @channel_finder ||= ChannelFinder.new(current_ability, params)
    end

    def find_channel
      @channel = current_staff.line_account.channels.find params[:id]
    rescue
      render_bad_request_with_message t('errors.messages.channel_not_found')
    end
end
