# frozen_string_literal: true

module Api
  module V1
    class BaseController < ActionController::API
      include ApiErrorHandler
      include ApiResponseHelper
      
      before_action :authenticate_request
      before_action :set_locale
      
      private
      
      def authenticate_request
        @current_user = AuthorizationService.authorize_request(request.headers)
      rescue JWT::DecodeError => e
        respond_with_unauthorized(message: 'Invalid token')
      rescue JWT::ExpiredSignature => e
        respond_with_unauthorized(message: 'Token has expired')
      end
      
      def current_user
        @current_user
      end
      
      def set_locale
        I18n.locale = params[:locale] || I18n.default_locale
      end
      
      # Pagination helpers
      def page_params
        {
          page: params[:page] || 1,
          per_page: params[:per_page] || 20
        }
      end
      
      def paginate(collection)
        collection.page(page_params[:page]).per(page_params[:per_page])
      end
    end
  end
end