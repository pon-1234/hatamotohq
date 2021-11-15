# frozen_string_literal: true

module SurveysHelper
  def build_answer(survey, params)
    friend = LineFriend.find_by(line_user_id: params[:friend_id])
    old_response = SurveyResponse.find_by(survey: survey, line_friend: friend)
    if old_response.present? && !survey.re_answer?
      return raise 'You are already responsed!'
    end
    response = SurveyResponse.new(survey: survey, line_friend: friend)
    response.answer_count += 1
    response.save!

    answer_params = params[:answers]
    answer_params.each do |k, answer|
      survey_answer = SurveyAnswer.new(survey_response: response)
      survey_answer.survey_question_id = answer[:id]
      question = SurveyQuestion.find(survey_answer.survey_question_id)

      if question.file?
        survey_answer.file = answer[:answer]
      else
        survey_answer.answer = answer[:answer]
      end
      survey_answer.save!

      variable = question.content['variable']
      assign_variable(friend, variable, survey_answer) if variable.present? && variable['id'].present?
    end
    AfterAnsweredSurveyJob.perform_later(response.id)
  end

  private
    def assign_variable(friend, variable, answer)
      friend_variable = FriendVariable.find_or_initialize_by(line_friend: friend, variable_id: variable['id'], survey_answer_id: answer.id)
      if answer.survey_question.file?
        friend_variable.value = rails_blob_url(answer.file) if answer.file.attached?
      else
        friend_variable.value = answer.answer
      end
      friend_variable.save!
    end
end
