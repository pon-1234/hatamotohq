# frozen_string_literal: true

class User::RemindersController < User::ApplicationController
  before_action :find_reminder, only: [:update]
  include User::ReminderHelper

  # GET /user/reminders
  def index
    if request.format.json?
      @folders = Folder.accessible_by(current_ability).type_reminder
    end
    respond_to do |format|
      format.html
      format.json
    end
  end

  # GET /user/reminders/new
  def new
  end

  # GET /user/reminders/:id/edit
  def edit
    @reminder_id = params[:id]
  end

  # POST /user/reminders
  def create
    @reminder = build_reminder(reminder_params)
    unless @reminder.save
      render_bad_request_with_message(@reminder.first_error_message)
    end
  end

  private
    def reminder_params
      params.permit(
        :folder_id,
        :name
      )
    end
end
