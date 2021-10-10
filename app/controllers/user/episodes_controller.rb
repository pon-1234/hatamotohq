class User::EpisodesController < User::ApplicationController
  load_and_authorize_resource
  before_action :find_reminder
  include User::EpisodesHelper

  # GET /user/reminders/:id/episodes
  def index
    if request.format.json?
      @episodes = @reminder.episodes.ordered
    end
    respond_to do |format|
      format.html
      format.json
    end
  end

  # GET /user/reminders/:id/episodes/new
  def new
  end

  # POST /user/reminders/:id/episodes
  def create
    @episode = build_episode(episode_params)
    unless @episode.save
      render_bad_request_with_message(@episode.first_error_message)
    end
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
      @reminder = Reminder.find(params[:id])
    end
end
