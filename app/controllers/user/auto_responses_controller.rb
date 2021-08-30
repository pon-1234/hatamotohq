# frozen_string_literal: true

class User::AutoResponsesController < User::ApplicationController
  # GET /user/auto_responses
  def index
    @auto_responses = AutoResponse.all
    respond_to do |format|
      format.html
      format.json { render 'user/auto_responses/index_success.json.jbuilder' }
    end
  end
end
