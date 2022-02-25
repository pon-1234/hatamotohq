# frozen_string_literal: true

# == Schema Information
#
# Table name: review_questions
#
#  id          :bigint           not null, primary key
#  type        :string(255)
#  title       :string(255)
#  description :text(65535)
#  config      :json
#  sort_order  :integer
#  required    :boolean          default(TRUE)
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
class ReviewQuestion < ApplicationRecord
end
