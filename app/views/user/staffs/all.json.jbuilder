# frozen_string_literal: true

json.array! @staffs do |staff|
  json.(staff, :id, :email, :name)
  json.avatar_url staff.avatar_url
end
