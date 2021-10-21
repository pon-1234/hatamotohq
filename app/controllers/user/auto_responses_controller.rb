# frozen_string_literal: true

class User::AutoResponsesController < User::ApplicationController
  before_action :find_auto_response, only: [:show, :update, :copy, :destroy]

  include User::AutoResponsesHelper

  # GET /user/auto_responses
  def index
    @folders = Folder.accessible_by(current_ability).includes([auto_responses: [:auto_response_keywords, :auto_response_messages]]).type_auto_response
    respond_to do |format|
      format.html
      format.json
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

  # GET /user/auto_response/:id
  def edit
    @auto_response_id = params[:id]
  end

  # PATCH /user/auto_response/:id
  def update
    if @auto_response.update(update_auto_response_params.except(:keywords))
      if update_auto_response_params[:keywords].present?
        build_auto_response_keywords(@auto_response, update_auto_response_params[:keywords])
      end
      if params[:messages].present?
        build_auto_response_messages(@auto_response, messages_params)
      end
      respond_to do |format|
        format.html { redirect_to user_auto_responses_path, flash: { success: '自動応答の変更は完了しました。' } }
        format.json { render_success }
      end
    else
      respond_to do |format|
        format.html { redirect_to user_auto_responses_path, flash: { error: '自動応答の変更は失敗しました。' } }
        format.json { render_bad_request_with_message(@auto_response.first_error_message) }
      end
    end
  end

  # GET /user/auto_responses/:id
  def show
    respond_to do |format|
      format.json
    end
  end

  # POST /user/auto_responses/:id/copy
  def copy
    @auto_response.clone!
    render_success
  rescue => e
    logger.error e.message
    render_bad_request
  end

  # DELETE /user/auto_responses/:id
  def destroy
    @auto_response.destroy!
    render_success
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

    def update_auto_response_params
      params.permit(
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

    def find_auto_response
      @auto_response = AutoResponse.find(params[:id])
    end
end
