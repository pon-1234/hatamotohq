# frozen_string_literal: true

json.array! @site_measurements do |site_measurement|
  broadcast = site_measurement.broadcast_message.broadcast
  json.broadcast broadcast.as_json.merge(tags: broadcast.tags)
  json.(site_measurement, :site_id, :click_count, :sending_count, :receiver_count, :visitor_count, :real_site_url, :real_site_name)
  json.(site_measurement.broadcast_message, :content)
end
