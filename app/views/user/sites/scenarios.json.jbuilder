# frozen_string_literal: true

json.array! @site_measurements do |site_measurement|
  json.scenario_title site_measurement.scenario_message.scenario.title
  json.mode site_measurement.scenario_message.scenario.mode
  json.(site_measurement, :site_id, :click_count, :sending_count, :receiver_count, :visitor_count, :real_site_url, :real_site_name)
  json.(site_measurement.scenario_message, :content, :status, :is_initial, :date, :time)
end
