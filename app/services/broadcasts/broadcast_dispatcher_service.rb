# frozen_string_literal: true

module Broadcasts
  class BroadcastDispatcherService
    attr_reader :broadcast, :errors

    def initialize(broadcast)
      @broadcast = broadcast
      @errors = []
    end

    def dispatch
      return false unless can_dispatch?

      if @broadcast.deliver_now?
        dispatch_immediately
      else
        schedule_for_later
      end

      true
    rescue StandardError => e
      @errors << e.message
      false
    end

    private

    def can_dispatch?
      if @broadcast.draft?
        @errors << 'Cannot dispatch draft broadcast'
        return false
      end

      if @broadcast.sent?
        @errors << 'Broadcast has already been sent'
        return false
      end

      if @broadcast.sending?
        @errors << 'Broadcast is already being sent'
        return false
      end

      if @broadcast.broadcast_messages.empty?
        @errors << 'Broadcast has no messages'
        return false
      end

      true
    end

    def dispatch_immediately
      DispatchBroadcastJob.perform_later(@broadcast.id)
      @broadcast.update(status: 'sending')
    end

    def schedule_for_later
      if @broadcast.schedule_at.blank?
        @errors << 'Schedule time is required for scheduled broadcasts'
        raise StandardError, @errors.last
      end

      DispatchBroadcastJob.set(wait_until: @broadcast.schedule_at).perform_later(@broadcast.id)
      @broadcast.update(status: 'pending')
    end
  end
end