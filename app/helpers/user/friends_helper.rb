# frozen_string_literal: true

module User::FriendsHelper
  def render_friend_status(status)
    case status
    when 'active'
      "<i class='mdi mdi-circle text-success'></i> 正常".html_safe
    when 'blocked'
      "<i class='mdi mdi-circle text-warinig'></i> ブロック中".html_safe
    end
  end
end
