# frozen_string_literal: true

json.array! @variables do |variable|
  json.name variable['name']
  json.value variable['value']
  json.type variable['type']
end
