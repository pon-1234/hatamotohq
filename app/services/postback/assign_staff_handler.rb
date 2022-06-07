# frozen_string_literal: true

class Postback::AssignStaffHandler < Postback::BaseHandler
  def perform
    @friend.channel.update! assignee_id: @content['staff_id']
  rescue => exception
    puts exception.message
  end
end
