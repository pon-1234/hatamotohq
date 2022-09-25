# frozen_string_literal: true

json.(survey, :id, :folder_id, :name, :banner_url, :title, :description, :after_action, :status, :re_answer, :sync_to_ggsheet, :connected_to_ggsheet)
json.created_at survey.created_at.strftime('%Y-%m-%d %H:%M')
json.questions do
  json.array! survey.survey_questions do |question|
    json.partial! 'models/survey_question', question: question
  end
end
