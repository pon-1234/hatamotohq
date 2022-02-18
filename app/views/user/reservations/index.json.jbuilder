# frozen_string_literal: true

json.meta do
  json.total_pages @reservations.total_pages
  json.current_page @reservations.current_page
  json.total_count @reservations.total_count
  json.limit_value @reservations.limit_value
end
json.data do
  json.array! @reservations do |reservation|
    json.(reservation, :id, :room_id, :room_name, :status, :created_at)
    json.customer_name reservation.customer_name
  end
end
