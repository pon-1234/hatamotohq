# frozen_string_literal: true

class ReviewQuestionsController < ApplicationController
  # GET /user/review_questions
  def index
    @review_questions = ReviewQuestion.all.order(:sort_order)
    respond_to do |format|
      format.json
    end
  end
end
