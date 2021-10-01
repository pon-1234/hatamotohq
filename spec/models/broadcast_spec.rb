# frozen_string_literal: true

# == Schema Information
#
# Table name: broadcasts
#
#  id              :bigint           not null, primary key
#  line_account_id :bigint
#  conditions      :json
#  title           :string(255)
#  deliver_now     :boolean          default(TRUE)
#  status          :string(255)
#  type            :string(255)
#  schedule_at     :datetime
#  deliver_at      :datetime
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  deleted_at      :datetime
#
# Indexes
#
#  index_broadcasts_on_line_account_id  (line_account_id)
#
# Foreign Keys
#
#  fk_rails_...  (line_account_id => line_accounts.id)
#
require 'rails_helper'

RSpec.describe Broadcast, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
