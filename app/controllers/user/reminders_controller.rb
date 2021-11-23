# frozen_string_literal: true

class User::RemindersController < User::ApplicationController
  load_and_authorize_resource
  before_action :find_reminder, only: [:update, :show]
  include User::ReminderHelper

  # GET /user/reminders
  def index
    if request.format.json?
      @folders = Folder.accessible_by(current_ability).includes([:reminders]).type_reminder
    end
    respond_to do |format|
      format.html
      format.json
    end
  end

  # GET /user/reminders/:id
  def show
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

  # PATCH /user/reminders/:id
  def update
    unless @reminder.update!(reminder_params)
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

    def find_reminder
      @reminder = Reminder.find(params[:id])
    end
end
