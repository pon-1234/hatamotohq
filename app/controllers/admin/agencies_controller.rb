# frozen_string_literal: true

class Admin::AgenciesController < Admin::ApplicationController
  # GET /admin/agencies
  def index
    if request.format.json?
      @params = params[:q]
      @q = Agency.ransack(@params)
      @users = @q.result.page(params[:page])
    end
    respond_to do |format|
      format.html
      format.json
    end
  end
end
