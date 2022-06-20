# frozen_string_literal: true

class Postback::AssignStaffHandler < Postback::BaseHandler
  def perform
    assignee = User.staff.find_by(id: @content['staff_id'])
    @friend.channel.update_assignee(assignee)
  rescue => exception
    puts exception.message
  end
end
