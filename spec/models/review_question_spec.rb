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
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
require 'rails_helper'

RSpec.describe ReviewQuestion, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
