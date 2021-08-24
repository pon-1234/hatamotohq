# frozen_string_literal: true

module User::FriendsHelper
  def render_friend_status(status)
    case status
    when 'active'
      '<span class="badge badge-success p-2">正常</span>'
    when 'block'
      '<span class="badge badge-danger p-2">ブロック</span>'
    when 'mute'
      '<span class="badge badge-warning p-2">ミュート</span>'
    end
  end
end
