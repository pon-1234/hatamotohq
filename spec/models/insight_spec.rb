# frozen_string_literal: true

# == Schema Information
#
# Table name: insights
#
#  id               :bigint           not null, primary key
#  line_account_id  :bigint
#  type             :string(255)      default("daily")
#  date             :date
#  broadcast        :integer
#  targeting        :integer
#  auto_response    :integer
#  welcome_response :integer
#  chat             :integer
#  api_broadcast    :integer
#  api_push         :integer
#  api_multicast    :integer
#  api_narrowcast   :integer
#  api_reply        :integer
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#
# Indexes
#
#  index_insights_on_line_account_id  (line_account_id)
#
# Foreign Keys
#
#  fk_rails_...  (line_account_id => line_accounts.id)
#
require 'rails_helper'

RSpec.describe Insight, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
