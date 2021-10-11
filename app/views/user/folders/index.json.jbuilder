# frozen_string_literal: true

json.array! @folders do |folder|
  json.(folder, :id, :name)
end
