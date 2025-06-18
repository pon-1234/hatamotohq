# frozen_string_literal: true

module ApiErrorHandler
  extend ActiveSupport::Concern

  included do
    rescue_from StandardError, with: :handle_standard_error
    rescue_from ActiveRecord::RecordNotFound, with: :handle_not_found
    rescue_from ActiveRecord::RecordInvalid, with: :handle_record_invalid
    rescue_from ActionController::ParameterMissing, with: :handle_parameter_missing
    rescue_from CanCan::AccessDenied, with: :handle_access_denied
    rescue_from JWT::DecodeError, with: :handle_jwt_error
    rescue_from JWT::ExpiredSignature, with: :handle_jwt_expired
  end

  private

  def handle_standard_error(exception)
    log_error(exception)
    render_error(
      message: 'Internal server error occurred',
      status: :internal_server_error,
      code: 'INTERNAL_ERROR'
    )
  end

  def handle_not_found(exception)
    render_error(
      message: exception.message || 'Resource not found',
      status: :not_found,
      code: 'NOT_FOUND'
    )
  end

  def handle_record_invalid(exception)
    render_error(
      message: 'Validation failed',
      status: :unprocessable_entity,
      code: 'VALIDATION_ERROR',
      errors: format_validation_errors(exception.record.errors)
    )
  end

  def handle_parameter_missing(exception)
    render_error(
      message: "Required parameter missing: #{exception.param}",
      status: :bad_request,
      code: 'PARAMETER_MISSING',
      errors: { exception.param => ['is required'] }
    )
  end

  def handle_access_denied(exception)
    render_error(
      message: exception.message || 'Access denied',
      status: :forbidden,
      code: 'ACCESS_DENIED'
    )
  end

  def handle_jwt_error(exception)
    render_error(
      message: 'Invalid authentication token',
      status: :unauthorized,
      code: 'INVALID_TOKEN'
    )
  end

  def handle_jwt_expired(exception)
    render_error(
      message: 'Authentication token has expired',
      status: :unauthorized,
      code: 'TOKEN_EXPIRED'
    )
  end

  def render_error(message:, status:, code: nil, errors: nil)
    response_body = {
      error: {
        message: message,
        code: code || status.to_s.upcase,
        timestamp: Time.current.iso8601
      }
    }

    response_body[:error][:errors] = errors if errors.present?
    response_body[:error][:request_id] = request.request_id if request.request_id.present?

    render json: response_body, status: status
  end

  def render_success(data: nil, message: nil, meta: nil)
    response_body = {
      success: true,
      timestamp: Time.current.iso8601
    }

    response_body[:data] = data if data.present?
    response_body[:message] = message if message.present?
    response_body[:meta] = meta if meta.present?

    render json: response_body, status: :ok
  end

  def render_created(data: nil, message: 'Resource created successfully')
    response_body = {
      success: true,
      message: message,
      timestamp: Time.current.iso8601
    }

    response_body[:data] = data if data.present?

    render json: response_body, status: :created
  end

  def render_no_content
    head :no_content
  end

  def render_paginated(collection, serializer: nil, each_serializer: nil, meta: {})
    response_body = {
      success: true,
      data: serialize_collection(collection, serializer: serializer, each_serializer: each_serializer),
      meta: meta.merge(pagination_meta(collection)),
      timestamp: Time.current.iso8601
    }

    render json: response_body, status: :ok
  end

  private

  def format_validation_errors(errors)
    errors.messages.transform_values { |messages| messages.uniq }
  end

  def log_error(exception)
    Rails.logger.error "API Error: #{exception.class} - #{exception.message}"
    Rails.logger.error exception.backtrace.join("\n") if Rails.env.development?
  end

  def serialize_collection(collection, serializer: nil, each_serializer: nil)
    return collection unless serializer || each_serializer

    if serializer
      serializer.new(collection).as_json
    elsif each_serializer
      collection.map { |item| each_serializer.new(item).as_json }
    else
      collection
    end
  end

  def pagination_meta(collection)
    return {} unless collection.respond_to?(:current_page)

    {
      pagination: {
        current_page: collection.current_page,
        total_pages: collection.total_pages,
        total_count: collection.total_count,
        per_page: collection.limit_value,
        next_page: collection.next_page,
        prev_page: collection.prev_page
      }
    }
  end
end