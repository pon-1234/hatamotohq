class User::RemindersController < User::ApplicationController
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
end
