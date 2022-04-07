# frozen_string_literal: true

class User::ReviewsController < User::ApplicationController
  # GET /user/reviews
  def index
    if request.format.json?
      @q = Review.ransack(params[:q])
      @reviews = @q.result.where(client_id: current_user.client_id).last_reviews_of_friends.page(params[:page])
        .includes(:review_answers, :line_friend, :client)
    end
    respond_to do |format|
      format.html
      format.json
    end
  end
end
