# frozen_string_literal: true

json.data do
  json.array! @messages do |message|
    json.partial! 'models/message', message: message
  end
end
