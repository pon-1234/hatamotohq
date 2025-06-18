# frozen_string_literal: true

module ApiResponseHelper
  extend ActiveSupport::Concern

  # Success responses
  def respond_with_success(data: nil, message: nil, status: :ok)
    render json: success_response(data: data, message: message), status: status
  end

  def respond_with_created(resource, message: 'Created successfully')
    render json: success_response(data: resource, message: message), status: :created
  end

  def respond_with_updated(resource, message: 'Updated successfully')
    render json: success_response(data: resource, message: message), status: :ok
  end

  def respond_with_destroyed(message: 'Deleted successfully')
    render json: success_response(message: message), status: :ok
  end

  def respond_with_no_content
    head :no_content
  end

  # Error responses
  def respond_with_error(message:, status: :bad_request, code: nil, errors: nil)
    render json: error_response(message: message, code: code, errors: errors), status: status
  end

  def respond_with_not_found(resource_name = 'Resource')
    respond_with_error(
      message: "#{resource_name} not found",
      status: :not_found,
      code: 'NOT_FOUND'
    )
  end

  def respond_with_validation_error(resource)
    respond_with_error(
      message: 'Validation failed',
      status: :unprocessable_entity,
      code: 'VALIDATION_ERROR',
      errors: format_errors(resource.errors)
    )
  end

  def respond_with_unauthorized(message: 'Unauthorized')
    respond_with_error(
      message: message,
      status: :unauthorized,
      code: 'UNAUTHORIZED'
    )
  end

  def respond_with_forbidden(message: 'Forbidden')
    respond_with_error(
      message: message,
      status: :forbidden,
      code: 'FORBIDDEN'
    )
  end

  # Paginated responses
  def respond_with_paginated(collection, each_serializer: nil, **options)
    data = if each_serializer
             collection.map { |item| each_serializer.new(item).as_json }
           else
             collection
           end

    render json: paginated_response(data: data, collection: collection, **options), status: :ok
  end

  private

  def success_response(data: nil, message: nil)
    response = {
      success: true,
      timestamp: Time.current.iso8601
    }
    response[:data] = data if data
    response[:message] = message if message
    response
  end

  def error_response(message:, code: nil, errors: nil)
    {
      success: false,
      error: {
        message: message,
        code: code || 'ERROR',
        timestamp: Time.current.iso8601
      }.tap do |error|
        error[:errors] = errors if errors
        error[:request_id] = request.request_id if request.request_id
      end
    }
  end

  def paginated_response(data:, collection:, **options)
    success_response(data: data).merge(
      meta: {
        pagination: pagination_meta(collection)
      }.merge(options[:meta] || {})
    )
  end

  def pagination_meta(collection)
    {
      current_page: collection.current_page,
      total_pages: collection.total_pages,
      total_count: collection.total_count,
      per_page: collection.limit_value,
      has_next_page: !collection.last_page?,
      has_prev_page: !collection.first_page?
    }
  end

  def format_errors(errors)
    errors.messages.transform_values(&:uniq)
  end
end