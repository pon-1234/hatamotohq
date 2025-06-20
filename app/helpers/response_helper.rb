# frozen_string_literal: true

module ResponseHelper
  def render_success
    render json: { status: :success }, status: 200
  end

  def render_success_with_message(message)
    render json: { status: :success, message: message }, status: 200
  end

  def render_could_not_create_error(message)
    render json: { error: message }, status: :unprocessable_entity
  end

  def render_bad_request
    render json: { status: :error }, status: 400
  end

  def render_bad_request_with_message(message)
    render json: { status: :error, message: message }, status: 400
  end

  def render_permission_denied
    render json: { status: :error, message: 'Permission denied' }, status: 403
  end

  def render_server_error
    render json: { status: :error }, status: 500
  end
end
