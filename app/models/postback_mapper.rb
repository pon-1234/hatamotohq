# frozen_string_literal: true

# == Schema Information
#
# Table name: postback_mappers
#
#  id         :bigint           not null, primary key
#  key        :string
#  value      :json
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_postback_mappers_on_key  (key)
#
class PostbackMapper < ApplicationRecord
end
