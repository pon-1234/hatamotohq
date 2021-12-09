# frozen_string_literal: true

module User::ScenarioMessagesHelper
  def import_messages_from_template(scenario, template)
    template.template_messages.each do |message|
      scenario_message = ScenarioMessage.new
      scenario_message.scenario = scenario
      scenario_message.name = nil
      scenario_message.is_initial = true
      scenario_message.date = 0
      scenario_message.time = '00:00'
      scenario_message.order = 1
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
      "<i class='mdi mdi-circle text-success'></i> #{status_i18n}".html_safe
    when 'disabled'
      "<i class='mdi mdi-circle'></i> #{status_i18n}".html_safe
    end
  end

  def schedule_time_for(scenario, message)
    return '' if message.disabled?
    if scenario.elapsed_time_mode?
      if message.is_initial?
        '開始直後'
      else
        sb = message.date > 0 ? "#{message.date}日と" : ''
        sb + "#{message.time&.to_time.strftime('%-H時間%-M分')}後"
      end
    elsif scenario.time_mode?
      message.is_initial? ? "開始当日 #{message.time}" : "#{message.date}日後 #{message.time}"
    end
  end
end
