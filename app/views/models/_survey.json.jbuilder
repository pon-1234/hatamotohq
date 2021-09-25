json.(survey, :id, :folder_id, :name, :after_action, :status)
json.created_at survey.created_at.strftime('%Y-%m-%d %H:%M')
json.questions do
  json.array! survey.survey_questions do |question|
    json.partial! 'models/survey_question', question: question
  end
end