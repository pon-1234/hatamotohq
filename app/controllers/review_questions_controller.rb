# frozen_string_literal: true

class ReviewQuestionsController < User::ApplicationController
  # GET /user/medias
  def index
    @review_questions = ReviewQuestion.all.order(:sort_order)
    respond_to do |format|
      # binding.pry
      format.json
    end
  end
end
