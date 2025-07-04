# frozen_string_literal: true

class User::ChannelsController < User::ApplicationController
  load_resource

  # GET /user/channels
  def index
    authorize! :read, Channel
    @channels = channel_finder.perform
    respond_to do |format|
      format.html
      format.json
    end
  end

  # GET /user/channels/:id
  def show
    authorize! :read, @channel
    @channel_id = params[:id]
    @channels = channel_finder.perform
    respond_to do |format|
      format.html
      format.json
    end
  end

  # GET /user/channels/:channel_id/scenarios
  def scenarios
    authorize! :read, @channel
    @scenarios = @channel.line_friend.manual_scenarios
  end

  # POST /user/channels/:id/update_last_seen
  def update_last_seen
    authorize! :update, @channel
    @channel.last_seen_at = Time.zone.now
    @channel.save!
    render_success
  end

  # POST /user/channels/:id/assign
  def assign
    # if params[:assignee_id] is not a valid id, it will set to nil, hence unassigning the channel
    assignee = Current.user.client.staffs.find_by(id: params[:assignee_id])
    @channel.update_assignee(assignee)
    render_success
  end

  private
    def channel_finder
      @channel_finder ||= ChannelFinder.new(current_ability, params)
    end
end
