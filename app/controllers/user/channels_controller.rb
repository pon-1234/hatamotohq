# frozen_string_literal: true

class User::ChannelsController < User::ApplicationController
  load_and_authorize_resource
  before_action :find_channel, only: [:scenarios]

  # GET /user/channels
  def index
    @channels = Channel.accessible_by(current_ability).includes([:line_friend]).page(params[:page]).per(50)
    respond_to do |format|
      format.html
      format.json
    end
  end

  # GET /user/channels/:id
  def show
    @channel_id = params[:id]
    index
  end

  # GET /user/channels/:channel_id/scenarios
  def scenarios
    @scenarios = @channel.line_friend.manual_scenarios
  end

  # POST /user/channels/:id/update_last_seen
  def update_last_seen
    @channel.last_seen_at = Time.zone.now
    @channel.save!
  end

  private
    def find_channel
      @channel = Channel.find(params[:id])
    end
end
