# frozen_string_literal: true

module Broadcasts
  class BroadcastCloneService
    attr_reader :new_broadcast, :errors

    def initialize(original_broadcast)
      @original_broadcast = original_broadcast
      @errors = []
    end

    def clone
      @new_broadcast = duplicate_broadcast
      success = false
      
      ActiveRecord::Base.transaction do
        if @new_broadcast.save
          duplicate_messages
          duplicate_tags
          success = true
        else
          @errors.concat(@new_broadcast.errors.full_messages)
          raise ActiveRecord::Rollback
        end
      end
      
      success
    rescue ActiveRecord::Rollback
      false
    rescue StandardError => e
      @errors << e.message
      false
    end

    private

    def duplicate_broadcast
      new_broadcast = @original_broadcast.dup
      
      # Reset attributes
      new_broadcast.title = "#{@original_broadcast.title} (Copy)"
      new_broadcast.status = 'draft'
      new_broadcast.schedule_at = nil
      new_broadcast.deliver_now = false
      new_broadcast.created_at = nil
      new_broadcast.updated_at = nil
      
      new_broadcast
    end

    def duplicate_messages
      @original_broadcast.broadcast_messages.each do |original_message|
        new_message = original_message.dup
        new_message.broadcast = @new_broadcast
        new_message.created_at = nil
        new_message.updated_at = nil
        
        unless new_message.save
          @errors.concat(new_message.errors.full_messages)
          raise ActiveRecord::Rollback
        end
        
        duplicate_site_measurements(original_message, new_message)
      end
    end

    def duplicate_site_measurements(original_message, new_message)
      original_message.site_measurements.each do |original_measurement|
        new_measurement = original_measurement.dup
        new_measurement.measurable = new_message
        new_measurement.created_at = nil
        new_measurement.updated_at = nil
        
        # Reset statistics
        new_measurement.sending_count = 0
        new_measurement.click_count = 0
        new_measurement.receiver_count = 0
        new_measurement.visitor_count = 0
        
        unless new_measurement.save
          @errors.concat(new_measurement.errors.full_messages)
          raise ActiveRecord::Rollback
        end
      end
    end

    def duplicate_tags
      @new_broadcast.tag_ids = @original_broadcast.tag_ids
    end
  end
end