# frozen_string_literal: true

json.(staff, :id, :email, :name, :phone_number, :created_at, :status)
json.avatar_url staff.avatar_url
