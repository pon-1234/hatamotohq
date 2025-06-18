# frozen_string_literal: true

module Broadcasts
  class BroadcastMessageBuilderService
    attr_reader :errors

    def initialize(broadcast, messages_params, options = {})
      @broadcast = broadcast
      @messages_params = messages_params
      @options = options
      @errors = []
    end

    def build_messages
      return false unless valid?

      ActiveRecord::Base.transaction do
        remove_existing_messages
        create_new_messages
      end

      true
    rescue StandardError => e
      @errors << e.message
      false
    end

    private

    def valid?
      if @messages_params.blank? || @messages_params.empty?
        @errors << 'At least one message is required'
        return false
      end

      @messages_params.each_with_index do |message_params, index|
        if message_params[:content].blank?
          @errors << "Message #{index + 1} content cannot be blank"
        end
      end

      @errors.empty?
    end

    def remove_existing_messages
      # Delete site measurements first to avoid foreign key constraints
      @broadcast.broadcast_messages.each do |message|
        message.site_measurements.destroy_all
      end
      
      # Then delete the messages
      @broadcast.broadcast_messages.destroy_all
    end

    def create_new_messages
      @messages_params.each do |message_params|
        processed_params = process_message_params(message_params)
        
        broadcast_message = @broadcast.broadcast_messages.build(processed_params)
        
        unless broadcast_message.save
          @errors.concat(broadcast_message.errors.full_messages)
          raise ActiveRecord::Rollback
        end
      end
    end

    def process_message_params(params)
      processed = params.dup
      
      # Handle site measurements
      if @options[:skip_shorten_url] || params[:notUseShorternUrl]
        processed.delete(:site_measurements_attributes)
      else
        process_site_measurements(processed)
      end
      
      processed
    end

    def process_site_measurements(params)
      return unless params[:site_measurements_attributes]
      
      # Remove any existing IDs to ensure new records are created
      params[:site_measurements_attributes].each do |site_measurement|
        site_measurement.delete(:id) if site_measurement.is_a?(Hash)
      end
    end
  end
end