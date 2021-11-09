# frozen_string_literal: true

module SurveysHelper
  def build_answer(survey, params)
    @friend = LineFriend.find_by(line_user_id: params[:friend_id])
    response = SurveyResponse.new(survey: survey, line_friend: @friend)
    response.answer_count += 1
    response.save!

    answer_params = params[:answers]
    answer_params.each do |k, answer|
      survey_answer = SurveyAnswer.new(survey_response: response)
      survey_answer.survey_question_id = answer[:id]
      question = SurveyQuestion.find(survey_answer.survey_question_id)
      byebug
      if question.file?
        survey_answer.file = answer[:answer]
      else
        survey_answer.answer = answer[:answer]
      end
      survey_answer.save!
    end
  end
end
