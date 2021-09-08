# frozen_string_literal: true

module User::FriendsHelper
  def render_friend_status(status)
    case status
    when 'active'
      '<span class="badge badge-success p-2">有効</span>'.html_safe
    when 'blocked'
      '<span class="badge badge-warning p-2">ブロック</span>'.html_safe
    when 'muted'
      '<span class="badge badge-secondary p-2">ミュート</span>'.html_safe
    end
  end
end
