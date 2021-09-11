# frozen_string_literal: true

class PostbackHandler
  def initialize(line_account, event, action)
    @line_account = line_account
    @event = event
    @action = action
    friend_id = @event[:source][:userId]
    @friend = LineFriend.find_by(line_account: @line_account, line_user_id: friend_id)
  end

  def perform
    handle_tag_action(@action['tag']) if @action['tag'].present?
    true
  end

  def handle_tag_action(tag_actions)
    assign_action = tag_actions.find { |action| action['type'] == 'assign' }
    unassign_action = tag_actions.find { |action| action['type'] == 'unassign' }
    assign_tag(assign_action) if assign_action.present?
    unassign_tag(unassign_action) if unassign_action.present?
  end

  private
    def assign_tag(action)
      assign_ids = action['tags'].pluck('id')
      @friend.tag_ids = @friend.tag_ids | assign_ids
      @friend.save!
    end

    def unassign_tag(action)
      unassign_ids = action['tags'].pluck('id')
      @friend.tag_ids = @friend.tag_ids - unassign_ids
      @friend.save!
    end
end
