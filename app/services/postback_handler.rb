# frozen_string_literal: true

class PostbackHandler
  def initialize(line_account, event, action)
    @line_account = line_account
    @event = event
    @action = action
  end

  def perform
    byebug
    assign_tags(@action[]) if @action[:assign_tag].present
    true
  end

  def assign_tag
  end
end
