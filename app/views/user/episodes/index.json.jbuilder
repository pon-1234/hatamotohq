# frozen_string_literal: true

json.array! @episodes do |episode|
  json.partial! 'models/episode', episode: episode
end
