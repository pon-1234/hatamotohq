# frozen_string_literal: true

class User::EpisodesController < User::ApplicationController
  load_and_authorize_resource
  before_action :find_reminder
  before_action :find_episode, only: [:destroy]
  include User::EpisodesHelper

  # GET /user/reminders/:reminder_id/episodes
  def index
    if request.format.json?
      @episodes = @reminder.episodes.ordered
    end
    respond_to do |format|
      format.html
      format.json
    end
  end

  # GET /user/reminders/:reminder_id/episodes/new
  def new
  end

  # POST /user/reminders/:reminder_id/episodes
  def create
    @episode = build_episode(episode_params)
    unless @episode.save
      render_bad_request_with_message(@episode.first_error_message)
    end
  end

  # GET /user/reminders/:reminder_id/episodes/:id/edit
  def edit
  end

  # PATCH /user/reminders/:reminder_id/episodes/:id
  def update
  end

  # DELETE /user/reminders/:reminder_id/episodes/:id
  def destroy
    @episode.destroy!
    render_success
  end

  private
    def episode_params
      params.permit(
        :reminder_id,
        :is_initial,
        :date,
        :time,
        messages: [
          :message_type_id,
          content: {}
        ],
        actions: {},
      )
    end

    def find_reminder
      @reminder = Reminder.find(params[:reminder_id])
    end

    def find_episode
      @episode = Episode.find(params[:id])
    end
end
