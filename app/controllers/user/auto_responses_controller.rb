# frozen_string_literal: true

class User::AutoResponsesController < User::ApplicationController
  include User::AutoResponsesHelper

  # GET /user/auto_responses
  def index
    @folders = Folder.accessible_by(current_ability).type_auto_response
    respond_to do |format|
      format.html
      format.json { render 'user/auto_responses/index_success.json.jbuilder' }
    end
  end

  # GET /user/auto_responses/new?folder_id=:folder_id
  def new
  end

  # POST /user/auto_responses
  def create
    @auto_response = build_auto_response(auto_response_params)
  end

  private
    def auto_response_params
      params.permit(
        :name,
        :status,
        keywords: []
      )
    end

    def messages_params
      params.require(:message).map do |p|
        p.permit(:message_type_id, content: {})
      end
    end
end
