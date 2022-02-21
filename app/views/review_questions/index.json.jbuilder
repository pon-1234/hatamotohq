# frozen_string_literal: true

json.data do
  json.array! @review_questions do |question|
    json.(question, :id, :type, :title, :description, :config)
  end
end
