# frozen_string_literal: true

module User::ScenariosHelper
  def build_scenario(scenario_params)
    scenario = Scenario.new(scenario_params)
    scenario.line_account = current_user.line_account
    scenario
  end

  def render_scenario_status(status)
    return '' if status.blank?
    status_i18n = I18n.t('enums.scenario.status.' + status)
    case status
    when 'enable'
      "<span class='badge badge-primary p-2'>#{status_i18n}</span>"
    when 'disable'
      "<span class='badge badge-warning p-2'>#{status_i18n}</span>"
    when 'draft'
      "<span class='badge badge-secondary p-2'>#{status_i18n}</span>"
    end
  end
end
