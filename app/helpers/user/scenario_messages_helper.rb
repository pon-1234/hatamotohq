# frozen_string_literal: true

module User::ScenarioMessagesHelper
  def import_messages_from_template(scenario, template)
    template.template_messages.each do |message|
      scenario_message = ScenarioMessage.new
      scenario_message.scenario = scenario
      scenario_message.name = '未設定'
      scenario_message.is_initial = true
      scenario_message.date = 0
      scenario_message.time = '0:00'
      scenario_message.order = 0
      scenario_message.message_type_id = message.message_type_id
      scenario_message.content = message.content
      scenario_message.status = :disabled
      scenario_message.save!
    end
  end


  def render_scenario_message_status(status)
    return '' if status.blank?
    status_i18n = I18n.t('enums.scenario_message.status.' + status)
    case status
    when 'enabled'
      "<span class='badge badge-primary p-2'>#{status_i18n}</span>".html_safe
    when 'disabled'
      "<span class='badge badge-warning p-2'>#{status_i18n}</span>".html_safe
    end
  end

  def schedule_date_for(scenario, message)
    if scenario.elapsed_time_mode?
      message.is_initial? || message.date == 0 ? '開始直後' : ''
    elsif scenario.time_mode?
      message.is_initial? || message.date == 0 ? '開始当日' : "#{message.date}日後"
    end
  end

  def schedule_time_for(scenario, message)
    if scenario.elapsed_time_mode?
      if message.is_initial?
        "#{message.order}通目"
      else
        sb = message.date > 0 ? "#{message.date}日と" : ''
        sb + "#{message.time&.to_time.strftime('%-H時間%-M分')}後 #{message.order}通目"
      end
    elsif scenario.time_mode?
      "#{message.time} #{message.order}通目"
    end
  end
end
