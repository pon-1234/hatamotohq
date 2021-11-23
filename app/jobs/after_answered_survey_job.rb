# frozen_string_literal: true

class AfterAnsweredSurveyJob < ApplicationJob
  queue_as :default

  def perform(response_id)
    @response = SurveyResponse.find_by_id(response_id)
    return if @response.nil?
    # Invoke action based on selected options
    invoke_action

    # Invoke action after answer survey
    invoke_after_action if @response.survey.after_action.present?
  end

  private
    def invoke_action
      answers = @response.survey_answers
      # Handle action for each answer
      answers.each do |answer|
        # Only selectable question includes actions
        next unless answer.survey_question.selectable?
        # Find the corresponding action to invoke
        option = corresponding_answer_option(answer)
        ActionHandlerJob.perform_later(@response.line_friend, option)
      end
    end

    def corresponding_answer_option(answer)
      options = answer.survey_question.content['options']
      options.detect { |o| o['value']&.eql?(answer.answer) }
    end

    def invoke_after_action
      ActionHandlerJob.perform_later(@response.line_friend, @response.survey.after_action['data'])
    end
end
