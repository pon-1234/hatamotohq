# frozen_string_literal: true

class Postback::AssignOrUnassignTagHandler < Postback::BaseHandler
  def perform
    assign_action = @content.find { |action| action['type'] == 'assign' }
    unassign_action = @content.find { |action| action['type'] == 'unassign' }
    assign_tag(assign_action) if assign_action.present?
    unassign_tag(unassign_action) if unassign_action.present?
    @friend.send_suitable_rich_menu
  end

  def assign_tag(action)
    assign_ids = action['tags'].pluck('id')
    # to avoid exception, check existing before save
    tag_ids = Tag.where(id: assign_ids).pluck(:id)
    @friend.tag_ids = @friend.tag_ids | tag_ids
    @friend.save!
  end

  def unassign_tag(action)
    unassign_ids = action['tags'].pluck('id')
    @friend.tag_ids = @friend.tag_ids - unassign_ids
    @friend.save!
  end
end
