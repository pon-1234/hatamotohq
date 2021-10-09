class User::EpisodesController < User::ApplicationController
  before_action :find_reminder
  # GET /user/reminders/:id/episodes
  def index
    @episodes = @reminder.episodes
  end

  # GET /user/reminders/:id/episodes/new
  def new
  end

  private
    def find_reminder
      @reminder = Reminder.find(params[:id])
    end
end
