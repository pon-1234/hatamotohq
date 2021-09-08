# frozen_string_literal: true

module Admin::UsersHelper
  def render_user_status(status)
    case status
    when 'active'
      '<span class="badge badge-success p-2">有効</span>'.html_safe
    when 'blocked'
      '<span class="badge badge-warning p-2">ブロック中</span>'.html_safe
    end
  end
end
