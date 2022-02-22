# frozen_string_literal: true
json.meta do
  json.total_pages @reviews.total_pages
  json.current_page @reviews.current_page
  json.total_count @reviews.total_count
  json.limit_value @reviews.limit_value
end
json.data do
  json.array! @reviews do |review|
    json.(review, :id)
    json.line_name review.line_friend&.line_name
    json.client_name review.client&.name
    review.review_answers.each_with_index do |answer, index|
      json.set! "answer_of_question#{index.next}", answer.answer
    end
    json.created_at review.created_at
  end
end
