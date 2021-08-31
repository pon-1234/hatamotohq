# frozen_string_literal: true

class User::AutoResponsesController < User::ApplicationController
  include User::AutoResponsesHelper

  # GET /user/auto_responses
  def index
    @folders = Folder.accessible_by(current_ability).includes([auto_responses: [:auto_response_keywords, :auto_response_messages]]).type_auto_response
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
    if @auto_response.save
      build_auto_response_keywords(@auto_response, auto_response_params[:keywords])
      build_auto_response_messages(@auto_response, messages_params)
      redirect_to user_auto_responses_path, flash: { success: '自動応答の作成は完了しました。' }
    else
      render_bad_request_with_message(@auto_response.first_error_message)
    end
  end

  private
    def auto_response_params
      params.permit(
        :folder_id,
        :name,
        :status,
        keywords: []
      )
    end

    def messages_params
      params.require(:messages).map do |p|
        p.permit(:message_type_id, content: {})
      end
    end
end
