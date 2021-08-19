# frozen_string_literal: true

# == Schema Information
#
# Table name: postback_checksums
#
#  id         :bigint           not null, primary key
#  data       :string(255)
#  hash       :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class PostbackChecksum < ApplicationRecord
end
