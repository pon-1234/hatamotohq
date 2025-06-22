
# frozen_string_literal: true

module ApplicationHelper
  def controller?(*controller)
    controller.include?(params[:controller])
  end

  def action?(*action)
    action.include?(params[:action])
  end

  def unread_count
    count = Current.user.line_account.channels.sum { |channel| channel.unread_messages.count }
    count > 99 ? '99+' : count
  end

  def custom_flash_message
    return ''.html_safe unless defined?(flash) && flash.present?
    
    flash_messages = []
    flash.each do |type, message|
      type = 'success' if type == 'notice'
      type = 'error' if type == 'alert'
      text = "<script type='application/javascript'>toastr.#{type}('#{message}');</script>"
      flash_messages << text.html_safe unless message.blank?
    end
    flash_messages.join("\n").html_safe
  end

  def error_message_for(object, field_name)
    if object.errors.any?
      if !object.errors.messages[field_name].blank?
        object.errors.messages[field_name].join(', ')
      end
    end
  end

  def formatted_time(time)
    time&.strftime('%Y.%m.%d %H:%M')
  end

  def mobile_device?
    browser = Browser.new(request.user_agent)
    browser.device.mobile?
  end
end
