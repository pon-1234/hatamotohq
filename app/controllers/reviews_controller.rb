# frozen_string_literal: true

class ReviewsController < ApplicationController
  # GET /reviews/new/:friend_line_id
  def new
    @friend_line_id = params[:friend_line_id]
  end

  # POST /reviews/:friend_line_id
  def create
    friend = LineFriend.find_by!(line_user_id: params[:review][:friend_line_id])
    client_id = friend.line_account.client_id
    processed_review_params = review_params.merge({ client_id: client_id, line_friend_id: friend.id })
    review = Review.new processed_review_params
    if review.save
      redirect_to review_result_path
    else
      redirect_to review_new_path, alert: 'サービス評価の送信が失敗しました。'
    end
  rescue
    redirect_to review_new_path, alert: 'サービス評価の送信が失敗しました。'
  end

  # GET /reviews/result
  def result; end

  private
    def review_params
      params.require(:review).permit(review_answers_attributes: [:review_question_id, :answer])
    end
end
