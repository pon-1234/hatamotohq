# frozen_string_literal: true

json.array! @scenarios do |scenario|
  json.partial! 'models/scenario', scenario: scenario
end
