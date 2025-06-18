# frozen_string_literal: true

module Broadcasts
  class BroadcastBuilderService
    attr_reader :broadcast, :errors

    def initialize(line_account, params)
      @line_account = line_account
      @params = params
      @errors = []
    end

    def build
      @broadcast = Broadcast.new(broadcast_attributes)
      validate_broadcast
      @broadcast
    end

    def update(broadcast)
      @broadcast = broadcast
      @broadcast.assign_attributes(broadcast_attributes)
      validate_broadcast
      @broadcast
    end

    private

    def broadcast_attributes
      conditions = determine_conditions
      
      {
        line_account: @line_account,
        title: @params[:title],
        conditions: conditions,
        type: @params[:type],
        schedule_at: @params[:schedule_at],
        deliver_now: @params[:deliver_now],
        status: @params[:status],
        tag_ids: @params[:tag_ids]
      }.compact
    end

    def determine_conditions
      type = @params[:type] || 'all'
      
      if type == 'all'
        Broadcast::CONDITION_SEND_ALL
      else
        @params[:conditions]
      end
    end

    def validate_broadcast
      if @broadcast.title.blank?
        @errors << 'Title is required'
      end

      if @broadcast.schedule_at.present? && @broadcast.deliver_now
        @errors << 'Cannot set both schedule_at and deliver_now'
      end

      if @broadcast.schedule_at.present? && @broadcast.schedule_at < Time.current
        @errors << 'Schedule time must be in the future'
      end

      @errors.concat(@broadcast.errors.full_messages) unless @broadcast.valid?
    end
  end
end