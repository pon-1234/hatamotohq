# frozen_string_literal: true

json.(@message, :id, :scenario_id, :name, :is_initial, :date, :time, :order, :status, :message_type_id, :content)
json.site_measurements do
  json.array! @message.site_measurements, :id, :actions, :site_id, :site_name, :redirect_url
end
