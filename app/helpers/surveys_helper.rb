# frozen_string_literal: true

module SurveysHelper
  def build_answer(survey, params)
    @friend = LineFriend.find_by(line_user_id: params[:friend_id])
    survey_friend = SurveyResponse.find_or_create_by(survey: survey, line_friend: @friend)
    survey_friend.answer_count += 1
    survey_friend.save!

    answer_params = params[:answers]
    answer_params.each do |answer|
      survey_answer = SurveyAnswer.new(survey: survey, line_friend: @friend)
      survey_answer.survey_question_id = answer_params[:id]
      survey_answer.answer = answer_params[:answer]
      survey_answer.save!
    end
  end
end
