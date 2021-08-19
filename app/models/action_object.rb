# frozen_string_literal: true

# == Schema Information
#
# Table name: action_objects
#
#  id          :bigint           not null, primary key
#  description :text(65535)
#  format      :json
#  title       :string(255)
#  type        :string(255)
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
class ActionObject < ApplicationRecord
end
