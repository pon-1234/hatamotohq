# frozen_string_literal: true

module Admin::UsersHelper
  def render_user_status(status)
    case status
    when 'active'
      '<i class="mdi mdi-circle text-success"></i> 有効'.html_safe
    when 'blocked'
      '<i class="mdi mdi-circle text-warning"></i> ブロック中'.html_safe
    end
  end
end
