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
    end

    def invoke_after_action
      ActionHandlerJob.perform_now(@response.line_friend, @response.survey.after_action['data'])
    end
end
