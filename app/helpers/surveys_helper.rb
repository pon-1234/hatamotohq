# frozen_string_literal: true

module SurveysHelper
  def build_answer(survey, params)
    @friend = LineFriend.find_by(line_user_id: params[:friend_id])
    survey_friend = SurveyFriend.find_or_create_by(survey: survey, line_friend: @friend)
    survey_friend.answer_count += 1
    survey_friend.save!

    answer_params = params[:answers]
    answer_params.each do |answer|
      p '----answer----'
      p answer
    end
  end
end
