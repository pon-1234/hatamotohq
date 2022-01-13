# frozen_string_literal: true

json.array! @reservations do |reservation|
  json.(reservation, :id, :status, :created_at)
  json.customer_name reservation.customer_name
end
