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
    when 'enabled'
      "<i class='mdi mdi-circle text-primary'></i> #{status_i18n}".html_safe
    when 'disabled'
      "<i class='mdi mdi-circle text-warning'></i> #{status_i18n}".html_safe
    when 'draft'
      "<i class='mdi mdi-circle text-secondary'></i> #{status_i18n}".html_safe
    end
  end
end
