# frozen_string_literal: true

class Postback::ContactRsvHandler < Postback::BaseHandler
  def perform
    response = Pms::GetGuest.new.perform(@friend.line_user_id)
    # TODO this api
  end
end
