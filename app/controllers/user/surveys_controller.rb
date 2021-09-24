class User::SurveysController < User::ApplicationController
  # GET /user/surveys
  def index
    @folders = Folder.accessible_by(current_ability).type_survey
    respond_to do |format|
      format.html
      format.json
    end
  end

  # GET /user/surveys/:id/new
  def new
  end
end
